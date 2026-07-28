{{flutter_js}}
{{flutter_build_config}}

// Flutter's generated service worker is deprecated and unregisters itself.
// The application service worker is registered by index.html instead.
_flutter.loader.load({
	onEntrypointLoaded: async (engineInitializer) => {
		const appRunner = await engineInitializer.initializeEngine();
		await appRunner.runApp();

		requestAnimationFrame(() => {
			requestAnimationFrame(() => {
				const splash = document.getElementById('pwa-splash');
				splash?.classList.add('pwa-splash--hidden');
				window.setTimeout(() => splash?.remove(), 200);
			});
		});
	},
});