# Taskwell

An offline Flutter web to-do list manager. Tasks are stored locally in the
browser, so each browser keeps its own data.

## GitHub Pages deployment

The workflow at [.github/workflows/deploy-pages.yml](.github/workflows/deploy-pages.yml)
tests the project, builds the release web app, and deploys it whenever changes
are pushed to `main`. It also supports manual runs from the **Actions** tab.

### One-time GitHub setup

1. Open the repository **Settings** → **Pages**.
2. Under **Build and deployment**, set **Source** to **GitHub Actions**.
3. Push this workflow to `main`, then wait for **Deploy Flutter web app to
	GitHub Pages** to succeed.

The app is published at https://todo.catoyeung.com/. The repository URL
https://mecatoyeung.github.io/flutter_todo/ redirects there.

The configured GitHub Pages custom domain serves the app from `/`, so the
workflow builds Flutter with `/` as its web base path. This ensures all web
assets load from the custom-domain root.
