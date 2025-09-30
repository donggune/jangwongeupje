-- Row Level Security (RLS) 활성화 및 정책 설정

-- RLS 활성화
ALTER TABLE jangwon_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE jangwon_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE jangwon_agendas ENABLE ROW LEVEL SECURITY;
ALTER TABLE jangwon_solutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE jangwon_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE jangwon_comments ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 사용자 테이블 정책
-- ========================================

-- 모든 사용자 정보 조회 가능 (프로필 보기용)
CREATE POLICY "Anyone can view user profiles"
ON jangwon_users FOR SELECT
USING (true);

-- 자신의 정보만 수정 가능
CREATE POLICY "Users can update own profile"
ON jangwon_users FOR UPDATE
USING (auth.uid() = id);

-- ========================================
-- 카테고리 테이블 정책
-- ========================================

-- 모든 사용자가 카테고리 조회 가능
CREATE POLICY "Anyone can view categories"
ON jangwon_categories FOR SELECT
USING (true);

-- 관리자만 카테고리 생성/수정/삭제 가능
CREATE POLICY "Only admins can manage categories"
ON jangwon_categories FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM jangwon_users
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- ========================================
-- 과제 테이블 정책
-- ========================================

-- 모든 사용자가 과제 조회 가능
CREATE POLICY "Anyone can view agendas"
ON jangwon_agendas FOR SELECT
USING (true);

-- 관리자만 과제 생성 가능
CREATE POLICY "Only admins can create agendas"
ON jangwon_agendas FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM jangwon_users
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- 관리자만 과제 수정/삭제 가능
CREATE POLICY "Only admins can update agendas"
ON jangwon_agendas FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM jangwon_users
    WHERE id = auth.uid() AND role = 'admin'
  )
);

CREATE POLICY "Only admins can delete agendas"
ON jangwon_agendas FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM jangwon_users
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- ========================================
-- 답안 테이블 정책
-- ========================================

-- 모든 사용자가 답안 조회 가능
CREATE POLICY "Anyone can view solutions"
ON jangwon_solutions FOR SELECT
USING (true);

-- 인증된 사용자만 답안 작성 가능
CREATE POLICY "Authenticated users can create solutions"
ON jangwon_solutions FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- 작성자만 자신의 답안 수정 가능
CREATE POLICY "Users can update own solutions"
ON jangwon_solutions FOR UPDATE
USING (auth.uid() = author_id);

-- 작성자 또는 관리자만 답안 삭제 가능
CREATE POLICY "Users can delete own solutions"
ON jangwon_solutions FOR DELETE
USING (
  auth.uid() = author_id OR
  EXISTS (
    SELECT 1 FROM jangwon_users
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- ========================================
-- 반응 테이블 정책
-- ========================================

-- 모든 사용자가 반응 조회 가능
CREATE POLICY "Anyone can view reactions"
ON jangwon_reactions FOR SELECT
USING (true);

-- 인증된 사용자만 반응 추가 가능
CREATE POLICY "Authenticated users can create reactions"
ON jangwon_reactions FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL AND auth.uid() = user_id);

-- 자신의 반응만 수정/삭제 가능
CREATE POLICY "Users can update own reactions"
ON jangwon_reactions FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own reactions"
ON jangwon_reactions FOR DELETE
USING (auth.uid() = user_id);

-- ========================================
-- 댓글 테이블 정책
-- ========================================

-- 모든 사용자가 댓글 조회 가능
CREATE POLICY "Anyone can view comments"
ON jangwon_comments FOR SELECT
USING (true);

-- 인증된 사용자만 댓글 작성 가능
CREATE POLICY "Authenticated users can create comments"
ON jangwon_comments FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- 작성자만 자신의 댓글 수정 가능
CREATE POLICY "Users can update own comments"
ON jangwon_comments FOR UPDATE
USING (auth.uid() = author_id);

-- 작성자 또는 관리자만 댓글 삭제 가능
CREATE POLICY "Users can delete own comments"
ON jangwon_comments FOR DELETE
USING (
  auth.uid() = author_id OR
  EXISTS (
    SELECT 1 FROM jangwon_users
    WHERE id = auth.uid() AND role = 'admin'
  )
);
