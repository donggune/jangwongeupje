<script lang="ts">
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import type { Agenda, Solution, Comment } from '$lib/types';
	import { sampleAgendas, sampleSolutions, sampleComments } from '$lib/data/sample-agendas';
	import {
		formatDate,
		getStatusText,
		getStatusColorClass,
		getCategoryColorStyle,
		formatCount
	} from '$lib/utils';

	// 상태 관리
	let agenda: Agenda | null = $state(null);
	let solutions: Solution[] = $state([]);
	let comments: Comment[] = $state([]);
	let loading = $state(true);
	let error = $state('');

	// 답안 작성 폼 상태
	let showSolutionForm = $state(false);
	let solutionTitle = $state('');
	let solutionContent = $state('');

	// 현재 과제 ID
	let agendaId = $derived($page.params.id || '');

	// 데이터 로드
	function loadAgendaData() {
		try {
			// 실제로는 API에서 데이터를 가져올 예정
			const foundAgenda = sampleAgendas.find(a => a.id === agendaId);
			
			if (!foundAgenda) {
				error = '과제를 찾을 수 없습니다.';
				loading = false;
				return;
			}

			agenda = foundAgenda;
			solutions = sampleSolutions.filter(s => s.agenda_id === agendaId);
			comments = sampleComments.filter(c => 
				solutions.some(s => s.id === c.solution_id)
			);
			
			loading = false;
		} catch (err) {
			error = '데이터를 불러오는 중 오류가 발생했습니다.';
			loading = false;
		}
	}

	// 답안 제출
	function handleSolutionSubmit(event: Event) {
		event.preventDefault();
		if (!solutionTitle.trim() || !solutionContent.trim()) {
			alert('제목과 내용을 모두 입력해주세요.');
			return;
		}

		// 실제로는 API로 전송할 예정
		const newSolution: Solution = {
			id: Date.now().toString(),
			agenda_id: agendaId,
			author_id: 'current-user',
			title: solutionTitle.trim(),
			content: solutionContent.trim(),
			likes_count: 0,
			dislikes_count: 0,
			comments_count: 0,
			created_at: new Date().toISOString(),
			updated_at: new Date().toISOString()
		};

		solutions = [newSolution, ...solutions];
		
		// 폼 초기화
		solutionTitle = '';
		solutionContent = '';
		showSolutionForm = false;
		
		alert('답안이 성공적으로 제출되었습니다!');
	}

	// 좋아요/싫어요 처리
	function handleReaction(solutionId: string, type: 'like' | 'dislike') {
		solutions = solutions.map(s => {
			if (s.id === solutionId) {
				if (type === 'like') {
					return { ...s, likes_count: s.likes_count + 1 };
				} else {
					return { ...s, dislikes_count: s.dislikes_count + 1 };
				}
			}
			return s;
		});
	}

	// 카테고리별 색상 가져오기
	function getCategoryColor(categoryName: string): string {
		const categoryColors: Record<string, string> = {
			'사회 정책': '#3b82f6',
			'환경 보전': '#059669',
			'교육 개혁': '#7c3aed',
			'기술 혁신': '#ea580c',
			'경제 발전': '#dc2626',
			'문화 진흥': '#db2777'
		};
		return categoryColors[categoryName] || '#6b7280';
	}

	onMount(() => {
		loadAgendaData();
	});
</script>

<svelte:head>
	<title>{agenda ? agenda.title : '과제 상세보기'} | 장원급제</title>
	<meta name="description" content={agenda ? agenda.description.substring(0, 150) + '...' : '과제 상세보기'} />
</svelte:head>

<div class="min-h-screen bg-gradient-to-br from-red-50 via-amber-50 to-orange-50">
	{#if loading}
		<!-- 로딩 상태 -->
		<div class="flex items-center justify-center min-h-screen">
			<div class="text-center">
				<div class="animate-spin rounded-full h-12 w-12 border-b-2 border-red-600 mx-auto mb-4"></div>
				<p class="text-gray-600">과제를 불러오는 중...</p>
			</div>
		</div>
	{:else if error}
		<!-- 오류 상태 -->
		<div class="flex items-center justify-center min-h-screen">
			<div class="text-center">
				<div class="text-6xl mb-4">❌</div>
				<h2 class="text-2xl font-bold text-gray-900 mb-4">오류가 발생했습니다</h2>
				<p class="text-gray-600 mb-6">{error}</p>
				<a href="/agenda" class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
					과제 목록으로 돌아가기
				</a>
			</div>
		</div>
	{:else if agenda}
		<!-- 과제 상세 내용 -->
		<div class="container mx-auto px-4 py-8">
			<!-- 브레드크럼 -->
			<nav class="mb-6">
				<ol class="flex items-center space-x-2 text-sm text-gray-600">
					<li><a href="/" class="hover:text-red-600">홈</a></li>
					<li><span class="mx-2">/</span></li>
					<li><a href="/agenda" class="hover:text-red-600">과제 목록</a></li>
					<li><span class="mx-2">/</span></li>
					<li class="text-gray-900 font-medium">과제 상세보기</li>
				</ol>
			</nav>

			<!-- 과제 헤더 -->
			<div class="bg-white rounded-2xl shadow-sm border border-gray-100 mb-8">
				<div class="p-8">
					<!-- 메타 정보 -->
					<div class="flex flex-wrap items-center gap-4 mb-6">
						<span
							class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium border"
							style={getCategoryColorStyle(getCategoryColor(agenda.category))}
						>
							{agenda.category}
						</span>
						<span
							class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium border {getStatusColorClass(agenda.status)}"
						>
							{getStatusText(agenda.status)}
						</span>
						<span class="text-sm text-gray-500">
							출제일: {formatDate(agenda.created_at)}
						</span>
						<span class="text-sm text-gray-500">
							답안 {formatCount(solutions.length)}개
						</span>
					</div>

					<!-- 제목 -->
					<h1 class="text-3xl font-bold text-gray-900 mb-6 leading-tight">
						{agenda.title}
					</h1>

					<!-- 내용 -->
					<div class="prose prose-lg max-w-none">
						{#each agenda.description.split('\n') as paragraph}
							{#if paragraph.trim()}
								<p class="mb-4 text-gray-700 leading-relaxed">{paragraph}</p>
							{/if}
						{/each}
					</div>
				</div>
			</div>

			<!-- 답안 작성 섹션 -->
			<div class="bg-white rounded-2xl shadow-sm border border-gray-100 mb-8">
				<div class="p-6 border-b border-gray-100">
					<div class="flex items-center justify-between">
						<h2 class="text-xl font-semibold text-gray-900">💡 답안 제출</h2>
						{#if !showSolutionForm}
							<button
								onclick={() => showSolutionForm = true}
								class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
							>
								답안 작성하기
							</button>
						{/if}
					</div>
				</div>

				{#if showSolutionForm}
					<div class="p-6">
						<form onsubmit={handleSolutionSubmit} class="space-y-4">
							<!-- 제목 입력 -->
							<div>
								<label for="solution-title" class="block text-sm font-medium text-gray-700 mb-2">
									답안 제목
								</label>
								<input
									id="solution-title"
									type="text"
									bind:value={solutionTitle}
									placeholder="답안의 핵심을 담은 제목을 입력하세요"
									class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
									required
								/>
							</div>

							<!-- 내용 입력 -->
							<div>
								<label for="solution-content" class="block text-sm font-medium text-gray-700 mb-2">
									답안 내용
								</label>
								<textarea
									id="solution-content"
									bind:value={solutionContent}
									placeholder="선비의 마음으로 깊이 사색하여 지혜로운 답안을 작성해주세요..."
									rows="10"
									class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent resize-vertical"
									required
								></textarea>
							</div>

							<!-- 버튼들 -->
							<div class="flex gap-3 justify-end">
								<button
									type="button"
									onclick={() => {
										showSolutionForm = false;
										solutionTitle = '';
										solutionContent = '';
									}}
									class="px-4 py-2 text-gray-700 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
								>
									취소
								</button>
								<button
									type="submit"
									class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
								>
									답안 제출
								</button>
							</div>
						</form>
					</div>
				{/if}
			</div>

			<!-- 답안 목록 -->
			<div class="bg-white rounded-2xl shadow-sm border border-gray-100">
				<div class="p-6 border-b border-gray-100">
					<h2 class="text-xl font-semibold text-gray-900">
						📜 제출된 답안 ({formatCount(solutions.length)}개)
					</h2>
				</div>

				{#if solutions.length === 0}
					<div class="p-12 text-center">
						<div class="text-6xl mb-4">📝</div>
						<h3 class="text-xl font-semibold text-gray-900 mb-2">아직 답안이 없습니다</h3>
						<p class="text-gray-600 mb-6">첫 번째 답안을 제출하여 토론을 시작해보세요!</p>
						<button
							onclick={() => showSolutionForm = true}
							class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
						>
							답안 작성하기
						</button>
					</div>
				{:else}
					<div class="divide-y divide-gray-100">
						{#each solutions as solution (solution.id)}
							<article class="p-6">
								<!-- 답안 헤더 -->
								<div class="flex items-start justify-between mb-4">
									<div>
										<h3 class="text-lg font-semibold text-gray-900 mb-2">
											{solution.title}
										</h3>
										<div class="flex items-center gap-4 text-sm text-gray-500">
											<span>선비 {solution.author_id}</span>
											<span>•</span>
											<span>{formatDate(solution.created_at)}</span>
										</div>
									</div>
								</div>

								<!-- 답안 내용 -->
								<div class="prose max-w-none mb-6">
									{#each solution.content.split('\n') as paragraph}
										{#if paragraph.trim()}
											<p class="mb-3 text-gray-700 leading-relaxed">{paragraph}</p>
										{/if}
									{/each}
								</div>

								<!-- 반응 버튼들 -->
								<div class="flex items-center gap-6 pt-4 border-t border-gray-100">
									<button
										onclick={() => handleReaction(solution.id, 'like')}
										class="flex items-center gap-2 text-gray-600 hover:text-green-600 transition-colors"
									>
										<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L9 7v13m-3-4H4a2 2 0 01-2-2v-4a2 2 0 012-2h2m5 0V9a2 2 0 012-2h.095c.5 0 .905.405.905.905 0 .714.211 1.412.608 2.006L15 11v2m-6-4h2"/>
										</svg>
										<span>{formatCount(solution.likes_count)}</span>
									</button>
									
									<button
										onclick={() => handleReaction(solution.id, 'dislike')}
										class="flex items-center gap-2 text-gray-600 hover:text-red-600 transition-colors"
									>
										<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14H5.236a2 2 0 01-1.789-2.894l3.5-7A2 2 0 018.736 3h4.018c.163 0 .326.02.485.06L17 4m-7 10v5a2 2 0 002 2h.095c.5 0 .905-.405.905-.905 0-.714.211-1.412.608-2.006L15 17V4m-6 4H7a2 2 0 00-2 2v4a2 2 0 002 2h2m3 0V8a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L9 7v6"/>
										</svg>
										<span>{formatCount(solution.dislikes_count)}</span>
									</button>

									<button class="flex items-center gap-2 text-gray-600 hover:text-blue-600 transition-colors">
										<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
										</svg>
										<span>댓글 {formatCount(solution.comments_count)}</span>
									</button>
								</div>
							</article>
						{/each}
					</div>
				{/if}
			</div>
		</div>
	{/if}
</div>
