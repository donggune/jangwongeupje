<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	import { page } from '$app/stores';

	let { children } = $props();

	// 네비게이션 메뉴
	const navItems = [
		{ href: '/', label: '홈', icon: '🏠' },
		{ href: '/agenda', label: '과제 목록', icon: '📜' },
		{ href: '/solutions', label: '답안 모음', icon: '💡' },
		{ href: '/about', label: '제도 소개', icon: '📚' }
	];

	// 현재 경로 확인
	let currentPath = $derived($page.url.pathname);
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<!-- 네비게이션 바 -->
<nav class="bg-white shadow-sm border-b border-red-100 sticky top-0 z-50">
	<div class="container mx-auto px-4">
		<div class="flex items-center justify-between h-16">
			<!-- 로고 -->
			<a href="/" class="flex items-center gap-2 text-xl font-bold text-red-600 hover:text-red-700 transition-colors">
				<span class="text-2xl">🎓</span>
				<span>장원급제</span>
			</a>

			<!-- 데스크톱 메뉴 -->
			<div class="hidden md:flex items-center gap-6">
				{#each navItems as item}
					<a
						href={item.href}
						class="flex items-center gap-2 px-3 py-2 rounded-lg text-gray-700 hover:text-red-600 hover:bg-red-50 transition-colors {currentPath === item.href ? 'text-red-600 bg-red-50 font-medium' : ''}"
					>
						<span class="text-sm">{item.icon}</span>
						<span>{item.label}</span>
					</a>
				{/each}
			</div>

			<!-- 모바일 메뉴 버튼 -->
			<button class="md:hidden p-2 text-gray-700 hover:text-red-600 transition-colors" aria-label="메뉴 열기">
				<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
				</svg>
			</button>
		</div>

		<!-- 모바일 메뉴 (간단 버전) -->
		<div class="md:hidden border-t border-red-100 py-2">
			<div class="flex gap-1 overflow-x-auto">
				{#each navItems as item}
					<a
						href={item.href}
						class="flex-shrink-0 flex flex-col items-center gap-1 px-3 py-2 rounded-lg text-xs text-gray-700 hover:text-red-600 hover:bg-red-50 transition-colors {currentPath === item.href ? 'text-red-600 bg-red-50 font-medium' : ''}"
					>
						<span>{item.icon}</span>
						<span>{item.label}</span>
					</a>
				{/each}
			</div>
		</div>
	</div>
</nav>

<!-- 메인 콘텐츠 -->
<main>
	{@render children?.()}
</main>

<!-- 푸터 -->
<footer class="bg-gray-900 py-8 text-white mt-auto">
	<div class="container mx-auto px-4 text-center">
		<div class="flex items-center justify-center gap-2 mb-4">
			<span class="text-2xl">🎓</span>
			<span class="text-xl font-bold">장원급제</span>
		</div>
		<p class="text-gray-400">현대의 과거제도를 통해 지혜를 나누다</p>
		<p class="text-sm text-gray-500 mt-2">&copy; 2024 장원급제. 모든 권리 보유.</p>
	</div>
</footer>
