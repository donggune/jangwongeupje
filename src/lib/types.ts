// 장원급제 플랫폼 타입 정의

export interface User {
  id: string;
  username: string;
  email: string;
  display_name: string;
  role: 'admin' | 'user';
  created_at: string;
  updated_at: string;
}

export interface Agenda {
  id: string;
  title: string;
  description: string;
  category: string;
  created_by: string;
  status: 'active' | 'closed' | 'resolved';
  solution_count: number;
  created_at: string;
  updated_at: string;
  author?: User;
}

export interface Solution {
  id: string;
  agenda_id: string;
  author_id: string;
  title: string;
  content: string;
  likes_count: number;
  dislikes_count: number;
  comments_count: number;
  created_at: string;
  updated_at: string;
  author?: User;
}

export interface Category {
  id: string;
  name: string;
  description: string;
  color: string;
  created_at: string;
}

export interface Comment {
  id: string;
  solution_id: string;
  author_id: string;
  content: string;
  parent_id?: string;
  created_at: string;
  updated_at: string;
  author?: User;
  replies?: Comment[];
}

export interface Reaction {
  id: string;
  user_id: string;
  solution_id: string;
  reaction_type: 'like' | 'dislike';
  created_at: string;
}

// 필터 옵션 타입
export interface AgendaFilter {
  category?: string;
  status?: Agenda['status'];
  search?: string;
  sortBy?: 'created_at' | 'solution_count' | 'updated_at';
  sortOrder?: 'asc' | 'desc';
}
