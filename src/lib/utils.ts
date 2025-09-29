// 유틸리티 함수들

/**
 * 날짜를 한국어 형식으로 포맷팅
 */
export function formatDate(dateString: string): string {
  const date = new Date(dateString);
  const now = new Date();
  const diff = now.getTime() - date.getTime();
  
  // 1분 미만
  if (diff < 60 * 1000) {
    return '방금 전';
  }
  
  // 1시간 미만
  if (diff < 60 * 60 * 1000) {
    const minutes = Math.floor(diff / (60 * 1000));
    return `${minutes}분 전`;
  }
  
  // 1일 미만
  if (diff < 24 * 60 * 60 * 1000) {
    const hours = Math.floor(diff / (60 * 60 * 1000));
    return `${hours}시간 전`;
  }
  
  // 7일 미만
  if (diff < 7 * 24 * 60 * 60 * 1000) {
    const days = Math.floor(diff / (24 * 60 * 60 * 1000));
    return `${days}일 전`;
  }
  
  // 그 외의 경우
  return date.toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}

/**
 * 상태를 한국어로 변환
 */
export function getStatusText(status: 'active' | 'closed' | 'resolved'): string {
  switch (status) {
    case 'active':
      return '진행 중';
    case 'resolved':
      return '해결됨';
    case 'closed':
      return '종료됨';
    default:
      return '알 수 없음';
  }
}

/**
 * 상태에 따른 색상 클래스 반환
 */
export function getStatusColorClass(status: 'active' | 'closed' | 'resolved'): string {
  switch (status) {
    case 'active':
      return 'bg-yellow-100 text-yellow-800 border-yellow-200';
    case 'resolved':
      return 'bg-green-100 text-green-800 border-green-200';
    case 'closed':
      return 'bg-gray-100 text-gray-800 border-gray-200';
    default:
      return 'bg-gray-100 text-gray-800 border-gray-200';
  }
}

/**
 * 카테고리 색상을 CSS 변수로 변환
 */
export function getCategoryColorStyle(color: string): string {
  return `background-color: ${color}15; border-color: ${color}; color: ${color}`;
}

/**
 * 텍스트를 지정된 길이로 자르고 말줄임표 추가
 */
export function truncateText(text: string, maxLength: number): string {
  if (text.length <= maxLength) {
    return text;
  }
  return text.slice(0, maxLength) + '...';
}

/**
 * 숫자를 한국어 단위로 포맷팅 (예: 1000 -> 1천)
 */
export function formatCount(count: number): string {
  if (count < 1000) {
    return count.toString();
  }
  if (count < 10000) {
    return `${Math.floor(count / 1000)}천`;
  }
  if (count < 100000) {
    return `${Math.floor(count / 10000)}만`;
  }
  return `${Math.floor(count / 10000)}만+`;
}
