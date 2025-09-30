-- 장원급제 플랫폼 데이터베이스 스키마
-- 모든 테이블에 jangwon_ 프리픽스 사용

-- 1. 사용자 테이블
CREATE TABLE IF NOT EXISTS jangwon_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 사용자 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_jangwon_users_email ON jangwon_users(email);
CREATE INDEX IF NOT EXISTS idx_jangwon_users_username ON jangwon_users(username);
CREATE INDEX IF NOT EXISTS idx_jangwon_users_role ON jangwon_users(role);

-- 2. 카테고리 테이블
CREATE TABLE IF NOT EXISTS jangwon_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  color VARCHAR(7), -- 헥스 컬러코드
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 카테고리 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_jangwon_categories_name ON jangwon_categories(name);

-- 3. 과제(의제) 테이블
CREATE TABLE IF NOT EXISTS jangwon_agendas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50) NOT NULL,
  created_by UUID REFERENCES jangwon_users(id) ON DELETE SET NULL,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'closed', 'resolved')),
  solution_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 과제 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_jangwon_agendas_category ON jangwon_agendas(category);
CREATE INDEX IF NOT EXISTS idx_jangwon_agendas_status ON jangwon_agendas(status);
CREATE INDEX IF NOT EXISTS idx_jangwon_agendas_created_by ON jangwon_agendas(created_by);
CREATE INDEX IF NOT EXISTS idx_jangwon_agendas_created_at ON jangwon_agendas(created_at DESC);

-- 4. 답안(해결책) 테이블
CREATE TABLE IF NOT EXISTS jangwon_solutions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agenda_id UUID REFERENCES jangwon_agendas(id) ON DELETE CASCADE,
  author_id UUID REFERENCES jangwon_users(id) ON DELETE CASCADE,
  title VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  likes_count INTEGER DEFAULT 0,
  dislikes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 답안 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_jangwon_solutions_agenda_id ON jangwon_solutions(agenda_id);
CREATE INDEX IF NOT EXISTS idx_jangwon_solutions_author_id ON jangwon_solutions(author_id);
CREATE INDEX IF NOT EXISTS idx_jangwon_solutions_created_at ON jangwon_solutions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_jangwon_solutions_likes ON jangwon_solutions(likes_count DESC);

-- 5. 반응(좋아요/싫어요) 테이블
CREATE TABLE IF NOT EXISTS jangwon_reactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES jangwon_users(id) ON DELETE CASCADE,
  solution_id UUID REFERENCES jangwon_solutions(id) ON DELETE CASCADE,
  reaction_type VARCHAR(10) NOT NULL CHECK (reaction_type IN ('like', 'dislike')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, solution_id)
);

-- 반응 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_jangwon_reactions_user_id ON jangwon_reactions(user_id);
CREATE INDEX IF NOT EXISTS idx_jangwon_reactions_solution_id ON jangwon_reactions(solution_id);

-- 6. 댓글 테이블
CREATE TABLE IF NOT EXISTS jangwon_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  solution_id UUID REFERENCES jangwon_solutions(id) ON DELETE CASCADE,
  author_id UUID REFERENCES jangwon_users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  parent_id UUID REFERENCES jangwon_comments(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 댓글 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_jangwon_comments_solution_id ON jangwon_comments(solution_id);
CREATE INDEX IF NOT EXISTS idx_jangwon_comments_author_id ON jangwon_comments(author_id);
CREATE INDEX IF NOT EXISTS idx_jangwon_comments_parent_id ON jangwon_comments(parent_id);
CREATE INDEX IF NOT EXISTS idx_jangwon_comments_created_at ON jangwon_comments(created_at DESC);

-- 트리거: updated_at 자동 업데이트
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 트리거 적용
CREATE TRIGGER update_jangwon_users_updated_at BEFORE UPDATE ON jangwon_users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_jangwon_agendas_updated_at BEFORE UPDATE ON jangwon_agendas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_jangwon_solutions_updated_at BEFORE UPDATE ON jangwon_solutions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_jangwon_comments_updated_at BEFORE UPDATE ON jangwon_comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 트리거: 답안 수 자동 업데이트
CREATE OR REPLACE FUNCTION update_solution_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE jangwon_agendas SET solution_count = solution_count + 1 WHERE id = NEW.agenda_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE jangwon_agendas SET solution_count = GREATEST(solution_count - 1, 0) WHERE id = OLD.agenda_id;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_agenda_solution_count
AFTER INSERT OR DELETE ON jangwon_solutions
FOR EACH ROW EXECUTE FUNCTION update_solution_count();

-- 트리거: 댓글 수 자동 업데이트
CREATE OR REPLACE FUNCTION update_comment_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE jangwon_solutions SET comments_count = comments_count + 1 WHERE id = NEW.solution_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE jangwon_solutions SET comments_count = GREATEST(comments_count - 1, 0) WHERE id = OLD.solution_id;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_solution_comment_count
AFTER INSERT OR DELETE ON jangwon_comments
FOR EACH ROW EXECUTE FUNCTION update_comment_count();

-- 트리거: 좋아요/싫어요 수 자동 업데이트
CREATE OR REPLACE FUNCTION update_reaction_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.reaction_type = 'like' THEN
            UPDATE jangwon_solutions SET likes_count = likes_count + 1 WHERE id = NEW.solution_id;
        ELSIF NEW.reaction_type = 'dislike' THEN
            UPDATE jangwon_solutions SET dislikes_count = dislikes_count + 1 WHERE id = NEW.solution_id;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.reaction_type = 'like' THEN
            UPDATE jangwon_solutions SET likes_count = GREATEST(likes_count - 1, 0) WHERE id = OLD.solution_id;
        ELSIF OLD.reaction_type = 'dislike' THEN
            UPDATE jangwon_solutions SET dislikes_count = GREATEST(dislikes_count - 1, 0) WHERE id = OLD.solution_id;
        END IF;
    ELSIF TG_OP = 'UPDATE' AND OLD.reaction_type != NEW.reaction_type THEN
        -- 반응 타입 변경 시
        IF OLD.reaction_type = 'like' THEN
            UPDATE jangwon_solutions SET likes_count = GREATEST(likes_count - 1, 0), dislikes_count = dislikes_count + 1 WHERE id = NEW.solution_id;
        ELSE
            UPDATE jangwon_solutions SET dislikes_count = GREATEST(dislikes_count - 1, 0), likes_count = likes_count + 1 WHERE id = NEW.solution_id;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_solution_reaction_count
AFTER INSERT OR UPDATE OR DELETE ON jangwon_reactions
FOR EACH ROW EXECUTE FUNCTION update_reaction_count();

COMMENT ON TABLE jangwon_users IS '장원급제 사용자(선비) 테이블';
COMMENT ON TABLE jangwon_categories IS '과제 분야 카테고리 테이블';
COMMENT ON TABLE jangwon_agendas IS '출제관이 내리는 과제 테이블';
COMMENT ON TABLE jangwon_solutions IS '선비들이 제출하는 답안 테이블';
COMMENT ON TABLE jangwon_reactions IS '답안에 대한 좋아요/싫어요 반응 테이블';
COMMENT ON TABLE jangwon_comments IS '답안에 대한 댓글 및 대댓글 테이블';
