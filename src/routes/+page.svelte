<script>
	import { onMount } from 'svelte';

	let mounted = false;

	onMount(() => {
		mounted = true;
	});
</script>

<svelte:head>
	<title>장원급제 | 현대의 과거제도, 지혜로운 답안을 구하다</title>
	<meta
		name="description"
		content="조선시대 과거제도를 현대적으로 해석한 문제 해결 플랫폼. 출제관이 내는 과제에 선비들이 답안을 제시하고 평가받는 지혜의 장"
	/>
</svelte:head>

<div class="min-h-screen bg-gradient-to-br from-red-50 via-amber-50 to-orange-50">
	<!-- Hero Section -->
	<section class="relative overflow-hidden">
		<div class="container mx-auto px-4 py-16 sm:py-24">
			<div class="mx-auto max-w-4xl text-center">
				<!-- 메인 헤딩 -->
				<h1 class="mb-6 text-4xl leading-tight font-bold text-gray-900 sm:text-5xl lg:text-6xl">
					<span class="bg-gradient-to-r from-red-600 to-orange-600 bg-clip-text text-transparent">
						장원급제
					</span>
					<br />
					<span class="text-3xl text-gray-700 sm:text-4xl lg:text-5xl">현대의 과거제도</span>
				</h1>

				<!-- 서브 헤딩 -->
				<p class="mb-8 text-xl leading-relaxed text-gray-600 sm:text-2xl">
					출제관이 내는 과제에 선비들이 지혜로운 답안을 제시하고<br class="hidden sm:block" />
					서로의 견해를 나누며 최고의 해법을 찾아가는 지혜의 장
				</p>

				<!-- CTA 버튼들 -->
				<div class="mb-16 flex flex-col justify-center gap-4 sm:flex-row">
					<a
						href="/agenda"
						class="transform rounded-xl bg-red-600 px-8 py-4 text-lg font-semibold text-white shadow-lg transition-all duration-200 hover:scale-105 hover:bg-red-700 hover:shadow-xl text-center"
					>
						과제 둘러보기
					</a>
					<a
						href="/about"
						class="transform rounded-xl border-2 border-red-300 px-8 py-4 text-lg font-semibold text-red-700 transition-all duration-200 hover:scale-105 hover:border-red-600 hover:text-red-600 text-center"
					>
						과거제도 소개
					</a>
				</div>
			</div>
		</div>

		<!-- 배경 장식 요소 - 전통 문양 -->
		<div class="pointer-events-none absolute top-0 left-0 h-full w-full overflow-hidden">
			<div
				class="absolute top-20 left-10 h-20 w-20 animate-pulse rounded-full bg-red-200 opacity-20"
			></div>
			<div
				class="absolute top-40 right-20 h-16 w-16 animate-pulse rounded-full bg-orange-200 opacity-20"
				style="animation-delay: 1s"
			></div>
			<div
				class="absolute bottom-40 left-20 h-12 w-12 animate-pulse rounded-full bg-amber-200 opacity-20"
				style="animation-delay: 2s"
			></div>
			<!-- 한국 전통 문양 추가 -->
			<div class="absolute top-32 right-32 text-6xl text-red-100 opacity-30">卍</div>
			<div class="absolute bottom-32 left-32 text-5xl text-orange-100 opacity-30">☯</div>
		</div>
	</section>

	<!-- Features Section -->
	<section class="bg-white py-16">
		<div class="container mx-auto px-4">
			<div class="mb-16 text-center">
				<h2 class="mb-4 text-3xl font-bold text-gray-900 sm:text-4xl">과거제도의 특징</h2>
				<p class="mx-auto max-w-2xl text-xl text-gray-600">
					조선시대 선비 정신을 계승한 현대적 지혜 공유의 장
				</p>
			</div>

			<div class="mx-auto grid max-w-6xl gap-8 md:grid-cols-3">
				<!-- Feature 1 -->
				<div
					class="transform rounded-2xl bg-gradient-to-br from-red-50 to-red-100 p-8 text-center transition-all duration-300 hover:scale-105 hover:shadow-lg"
				>
					<div
						class="mx-auto mb-6 flex h-16 w-16 items-center justify-center rounded-full bg-red-600"
					>
						<svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
							></path>
						</svg>
					</div>
					<h3 class="mb-4 text-xl font-semibold text-gray-900">출제관의 과제 출제</h3>
					<p class="leading-relaxed text-gray-600">
						출제관(관리자)이 시대적 과제를 엄선하여 출제하고, 분야별로 체계적으로 관리하여 효과적인
						문제 해결을 이끌어냅니다.
					</p>
				</div>

				<!-- Feature 2 -->
				<div
					class="transform rounded-2xl bg-gradient-to-br from-amber-50 to-amber-100 p-8 text-center transition-all duration-300 hover:scale-105 hover:shadow-lg"
				>
					<div
						class="mx-auto mb-6 flex h-16 w-16 items-center justify-center rounded-full bg-amber-600"
					>
						<svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"
							></path>
						</svg>
					</div>
					<h3 class="mb-4 text-xl font-semibold text-gray-900">선비들의 지혜로운 답안</h3>
					<p class="leading-relaxed text-gray-600">
						다양한 학문과 경험을 가진 선비들이 제시하는 깊이 있고 창의적인 답안들을 통해 최고의
						해법을 발견할 수 있습니다.
					</p>
				</div>

				<!-- Feature 3 -->
				<div
					class="transform rounded-2xl bg-gradient-to-br from-orange-50 to-orange-100 p-8 text-center transition-all duration-300 hover:scale-105 hover:shadow-lg"
				>
					<div
						class="mx-auto mb-6 flex h-16 w-16 items-center justify-center rounded-full bg-orange-600"
					>
						<svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
							></path>
						</svg>
					</div>
					<h3 class="mb-4 text-xl font-semibold text-gray-900">품평과 토론의 장</h3>
					<p class="leading-relaxed text-gray-600">
						선비들이 서로의 답안을 품평하고 의견을 나누며, 건설적인 토론을 통해 더욱 완성도 높은
						해법을 만들어갑니다.
					</p>
				</div>
			</div>
		</div>
	</section>

	<!-- How it Works Section -->
	<section class="bg-amber-50 py-16">
		<div class="container mx-auto px-4">
			<div class="mb-16 text-center">
				<h2 class="mb-4 text-3xl font-bold text-gray-900 sm:text-4xl">과거 응시 과정</h2>
				<p class="mx-auto max-w-2xl text-xl text-gray-600">
					조선시대 선비가 되어 3단계 과거 응시에 참여해보세요
				</p>
			</div>

			<div class="mx-auto grid max-w-5xl gap-8 md:grid-cols-3">
				<!-- Step 1 -->
				<div class="text-center">
					<div
						class="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-red-600 text-2xl font-bold text-white"
					>
						壹
					</div>
					<h3 class="mb-4 text-xl font-semibold text-gray-900">과제 탐독</h3>
					<p class="leading-relaxed text-gray-600">
						출제관이 내린 시대적 과제를 탐독하고, 관심 분야의 문제를 깊이 있게 살펴보세요.
					</p>
				</div>

				<!-- Step 2 -->
				<div class="text-center">
					<div
						class="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-amber-600 text-2xl font-bold text-white"
					>
						貳
					</div>
					<h3 class="mb-4 text-xl font-semibold text-gray-900">답안 작성</h3>
					<p class="leading-relaxed text-gray-600">
						선비의 마음으로 깊이 사색하여 지혜로운 답안을 작성하고 동료 선비들과 공유하세요.
					</p>
				</div>

				<!-- Step 3 -->
				<div class="text-center">
					<div
						class="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-orange-600 text-2xl font-bold text-white"
					>
						參
					</div>
					<h3 class="mb-4 text-xl font-semibold text-gray-900">품평과 토론</h3>
					<p class="leading-relaxed text-gray-600">
						다른 선비들의 답안을 품평하고 의견을 나누며, 학문적 토론을 통해 함께 성장하세요.
					</p>
				</div>
			</div>
		</div>
	</section>

	<!-- Statistics Section -->
	<section class="bg-white py-16">
		<div class="container mx-auto px-4">
			<div class="mx-auto grid max-w-4xl gap-8 text-center sm:grid-cols-2 lg:grid-cols-4">
				<div class="p-6">
					<div class="mb-2 text-3xl font-bold text-red-600 sm:text-4xl">25+</div>
					<div class="font-medium text-gray-600">출제된 과제</div>
				</div>
				<div class="p-6">
					<div class="mb-2 text-3xl font-bold text-amber-600 sm:text-4xl">150+</div>
					<div class="font-medium text-gray-600">제출된 답안</div>
				</div>
				<div class="p-6">
					<div class="mb-2 text-3xl font-bold text-orange-600 sm:text-4xl">80+</div>
					<div class="font-medium text-gray-600">참여 선비</div>
				</div>
				<div class="p-6">
					<div class="mb-2 text-3xl font-bold text-red-700 sm:text-4xl">12</div>
					<div class="font-medium text-gray-600">장원급제</div>
				</div>
			</div>
		</div>
	</section>

	<!-- CTA Section -->
	<section class="bg-gradient-to-r from-red-600 to-orange-600 py-16">
		<div class="container mx-auto px-4 text-center">
			<h2 class="mb-6 text-3xl font-bold text-white sm:text-4xl">과거 응시에 참여하세요</h2>
			<p class="mx-auto mb-8 max-w-2xl text-xl text-red-100">
				조선시대 선비가 되어 현대의 과제에 지혜로운 답을 제시해보세요
			</p>
			<div class="flex flex-col justify-center gap-4 sm:flex-row">
				<a
					href="/auth/register"
					class="transform rounded-xl bg-white px-8 py-4 text-lg font-semibold text-red-600 shadow-lg transition-all duration-200 hover:scale-105 hover:bg-gray-100 text-center"
				>
					선비 등록하기
				</a>
				<a
					href="/agenda"
					class="transform rounded-xl border-2 border-white px-8 py-4 text-lg font-semibold text-white transition-all duration-200 hover:scale-105 hover:bg-white hover:text-red-600 text-center"
				>
					과제 둘러보기
				</a>
			</div>
		</div>
	</section>

	<!-- Footer -->
	<footer class="bg-gray-900 py-12 text-white">
		<div class="container mx-auto px-4">
			<div class="grid gap-8 md:grid-cols-3">
				<div>
					<h3 class="mb-4 text-xl font-bold">장원급제 🎓</h3>
					<p class="leading-relaxed text-gray-400">
						조선시대 과거제도를 현대적으로 해석한 지혜 공유 플랫폼. 출제관과 선비들이 함께 만드는
						현대의 성균관
					</p>
				</div>
				<div>
					<h4 class="mb-4 font-semibold">과제 분야</h4>
					<ul class="space-y-2 text-gray-400">
						<li><a href="/agenda?category=사회 정책" class="transition-colors hover:text-white">사회 정책</a></li>
						<li><a href="/agenda?category=환경 보전" class="transition-colors hover:text-white">환경 보전</a></li>
						<li><a href="/agenda?category=교육 개혁" class="transition-colors hover:text-white">교육 개혁</a></li>
						<li><a href="/agenda?category=기술 혁신" class="transition-colors hover:text-white">기술 혁신</a></li>
						<li><a href="/agenda?category=경제 발전" class="transition-colors hover:text-white">경제 발전</a></li>
						<li><a href="/agenda?category=문화 진흥" class="transition-colors hover:text-white">문화 진흥</a></li>
					</ul>
				</div>
				<div>
					<h4 class="mb-4 font-semibold">과거제도 안내</h4>
					<ul class="space-y-2 text-gray-400">
						<li><a href="/about" class="transition-colors hover:text-white">제도 소개</a></li>
						<li><a href="/about#guide" class="transition-colors hover:text-white">응시 방법</a></li>
						<li><a href="/about#etiquette" class="transition-colors hover:text-white">선비 예절</a></li>
						<li><a href="/contact" class="transition-colors hover:text-white">문의하기</a></li>
					</ul>
				</div>
			</div>
			<div class="mt-8 border-t border-gray-800 pt-8 text-center text-gray-400">
				<p>&copy; 2024 장원급제. 현대의 과거제도를 통해 지혜를 나누다.</p>
			</div>
		</div>
	</footer>
</div>
