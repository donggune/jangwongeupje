<script lang="ts">
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import { goto } from '$app/navigation';
	import type { Agenda, Category, AgendaFilter } from '$lib/types';
	import { sampleAgendas, categories } from '$lib/data/sample-agendas';
	import {
		formatDate,
		getStatusText,
		getStatusColorClass,
		getCategoryColorStyle,
		truncateText,
		formatCount
	} from '$lib/utils';

	// 상태 관리
	let agendas: Agenda[] = $state([]);
	let filteredAgendas: Agenda[] = $state([]);
	let selectedCategory = $state('');
	let selectedStatus = $state('');
	let searchTerm = $state('');
	let sortBy: 'created_at' | 'solution_count' | 'updated_at' = $state('created_at');
	let sortOrder: 'asc' | 'desc' = $state('desc');

	// 필터링 및 정렬 함수
	function filterAndSortAgendas() {
		let result = [...agendas];

		// 카테고리 필터
		if (selectedCategory) {
			result = result.filter((agenda) => agenda.category === selectedCategory);
		}

		// 상태 필터
		if (selectedStatus) {
			result = result.filter((agenda) => agenda.status === selectedStatus);
		}

		// 검색어 필터
		if (searchTerm) {
			const term = searchTerm.toLowerCase();
			result = result.filter(
				(agenda) =>
					agenda.title.toLowerCase().includes(term) ||
					agenda.description.toLowerCase().includes(term)
			);
		}

		// 정렬
		result.sort((a, b) => {
			let aValue: any, bValue: any;

			switch (sortBy) {
				case 'solution_count':
					aValue = a.solution_count;
					bValue = b.solution_count;
					break;
				case 'updated_at':
					aValue = new Date(a.updated_at);
					bValue = new Date(b.updated_at);
					break;
				default:
					aValue = new Date(a.created_at);
					bValue = new Date(b.created_at);
			}

			if (sortOrder === 'asc') {
				return aValue > bValue ? 1 : -1;
			} else {
				return aValue < bValue ? 1 : -1;
			}
		});

		filteredAgendas = result;
	}

	// URL 파라미터로부터 초기값 설정
	function initializeFromURL() {
		const params = $page.url.searchParams;
		selectedCategory = params.get('category') || '';
		selectedStatus = params.get('status') || '';
		searchTerm = params.get('search') || '';
		sortBy = (params.get('sortBy') as any) || 'created_at';
		sortOrder = (params.get('sortOrder') as any) || 'desc';
	}

	// URL 업데이트 함수
	function updateURL() {
		const params = new URLSearchParams();
		if (selectedCategory) params.set('category', selectedCategory);
		if (selectedStatus) params.set('status', selectedStatus);
		if (searchTerm) params.set('search', searchTerm);
		if (sortBy !== 'created_at') params.set('sortBy', sortBy);
		if (sortOrder !== 'desc') params.set('sortOrder', sortOrder);

		const newURL = params.toString() ? `?${params.toString()}` : '/agenda';
		goto(newURL, { replaceState: true, noScroll: true });
	}

	// 반응형 상태 - Svelte 5 runes 모드에서 의존성 명시적 추적
	$effect(() => {
		// 의존성 변수들을 명시적으로 읽어서 추적하도록 함
		selectedCategory;
		selectedStatus; 
		searchTerm;
		sortBy;
		sortOrder;
		
		filterAndSortAgendas();
		if (typeof window !== 'undefined') {
			updateURL();
		}
	});

	// 카테고리별 색상 가져오기
	function getCategoryColor(categoryName: string): string {
		const category = categories.find((c) => c.name === categoryName);
		return category?.color || '#6b7280';
	}

	onMount(() => {
		// URL 파라미터로부터 초기값 설정
		initializeFromURL();
		
		// 실제로는 API에서 데이터를 가져올 예정
		agendas = sampleAgendas;
		filterAndSortAgendas();
	});
</script>

<svelte:head>
	<title>과제 목록 | 장원급제</title>
	<meta name="description" content="출제관이 내린 과제들을 살펴보고 지혜로운 답안을 제시해보세요." />
</svelte:head>

<div class="min-h-screen bg-gradient-to-br from-red-50 via-amber-50 to-orange-50">
	<!-- 헤더 섹션 -->
	<section class="bg-white shadow-sm border-b border-red-100">
		<div class="container mx-auto px-4 py-8">
			<div class="text-center mb-8">
				<h1 class="text-3xl font-bold text-gray-900 mb-4 sm:text-4xl">
					<span class="text-red-600">📜</span> 과제 목록
				</h1>
				<p class="text-xl text-gray-600 max-w-2xl mx-auto">
					출제관이 내린 시대적 과제들을 살펴보고, 선비의 지혜로 답안을 제시해보세요
				</p>
			</div>

			<!-- 필터 및 검색 -->
			<div class="bg-gray-50 rounded-2xl p-6 mb-8">
				<div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
					<!-- 검색 -->
					<div class="lg:col-span-2">
						<label for="search" class="block text-sm font-medium text-gray-700 mb-2">
							과제 검색
						</label>
						<input
							id="search"
							type="text"
							placeholder="과제 제목이나 내용으로 검색..."
							bind:value={searchTerm}
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
						/>
					</div>

					<!-- 카테고리 필터 -->
					<div>
						<label for="category" class="block text-sm font-medium text-gray-700 mb-2">
							분야별 분류
						</label>
						<select
							id="category"
							bind:value={selectedCategory}
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
						>
							<option value="">전체 분야</option>
							{#each categories as category}
								<option value={category.name}>{category.name}</option>
							{/each}
						</select>
					</div>

					<!-- 상태 필터 -->
					<div>
						<label for="status" class="block text-sm font-medium text-gray-700 mb-2">
							진행 상태
						</label>
						<select
							id="status"
							bind:value={selectedStatus}
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
						>
							<option value="">전체 상태</option>
							<option value="active">진행 중</option>
							<option value="resolved">해결됨</option>
							<option value="closed">종료됨</option>
						</select>
					</div>
				</div>

				<!-- 정렬 옵션 -->
				<div class="flex flex-wrap gap-4 mt-6 pt-4 border-t border-gray-200">
					<div class="flex items-center gap-2">
						<span class="text-sm font-medium text-gray-700">정렬:</span>
						<select
							bind:value={sortBy}
							class="px-3 py-1 text-sm border border-gray-300 rounded-md focus:ring-2 focus:ring-red-500 focus:border-transparent"
						>
							<option value="created_at">출제일</option>
							<option value="updated_at">최근 활동</option>
							<option value="solution_count">답안 수</option>
						</select>
					<button
						onclick={() => (sortOrder = sortOrder === 'asc' ? 'desc' : 'asc')}
						class="p-1 text-gray-500 hover:text-gray-700 transition-colors"
						title={sortOrder === 'asc' ? '오름차순' : '내림차순'}
					>
							{#if sortOrder === 'asc'}
								<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
								</svg>
							{:else}
								<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
								</svg>
							{/if}
						</button>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- 과제 목록 -->
	<section class="container mx-auto px-4 py-8">
		<!-- 결과 요약 -->
		<div class="mb-6 text-center">
			<p class="text-gray-600">
				총 <span class="font-semibold text-red-600">{formatCount(filteredAgendas.length)}</span>개의
				과제가 있습니다
			</p>
		</div>

		{#if filteredAgendas.length === 0}
			<!-- 빈 상태 -->
			<div class="text-center py-16">
				<div class="text-6xl mb-4">📜</div>
				<h3 class="text-xl font-semibold text-gray-900 mb-2">검색 결과가 없습니다</h3>
				<p class="text-gray-600 mb-6">다른 검색어나 필터를 시도해보세요</p>
				<button
					onclick={() => {
						selectedCategory = '';
						selectedStatus = '';
						searchTerm = '';
					}}
					class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
				>
					필터 초기화
				</button>
			</div>
		{:else}
			<!-- 과제 카드 그리드 -->
			<div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
				{#each filteredAgendas as agenda (agenda.id)}
					<article
						class="bg-white rounded-2xl shadow-sm hover:shadow-md transition-all duration-300 border border-gray-100 hover:border-red-200 group"
					>
						<!-- 카드 헤더 -->
						<div class="p-6 pb-4">
							<div class="flex items-start justify-between mb-4">
								<!-- 카테고리 배지 -->
								<span
									class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium border"
									style={getCategoryColorStyle(getCategoryColor(agenda.category))}
								>
									{agenda.category}
								</span>

								<!-- 상태 배지 -->
								<span
									class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium border {getStatusColorClass(
										agenda.status
									)}"
								>
									{getStatusText(agenda.status)}
								</span>
							</div>

							<!-- 제목 -->
							<h2 class="text-xl font-semibold text-gray-900 mb-3 group-hover:text-red-600 transition-colors">
								<a href="/agenda/{agenda.id}" class="block">
									{agenda.title}
								</a>
							</h2>

							<!-- 설명 -->
							<p class="text-gray-600 leading-relaxed mb-4">
								{truncateText(agenda.description.replace(/출제관이 내리는 과제:\s*/, ''), 120)}
							</p>
						</div>

						<!-- 카드 푸터 -->
						<div class="px-6 py-4 bg-gray-50 rounded-b-2xl">
							<div class="flex items-center justify-between text-sm text-gray-500">
								<div class="flex items-center gap-4">
									<!-- 답안 수 -->
									<div class="flex items-center gap-1">
										<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path
												stroke-linecap="round"
												stroke-linejoin="round"
												stroke-width="2"
												d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
											/>
										</svg>
										<span>{formatCount(agenda.solution_count)}개 답안</span>
									</div>
								</div>

								<!-- 날짜 -->
								<div class="text-right">
									<div>출제: {formatDate(agenda.created_at)}</div>
									{#if agenda.updated_at !== agenda.created_at}
										<div class="text-xs text-gray-400">
											활동: {formatDate(agenda.updated_at)}
										</div>
									{/if}
								</div>
							</div>
						</div>
					</article>
				{/each}
			</div>
		{/if}
	</section>
</div>
