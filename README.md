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

The app will be published at
https://mecatoyeung.github.io/flutter_todo/.

The workflow passes the repository name to Flutter as the web base path, so
assets load correctly on a project Pages URL. If the repository is renamed,
the workflow automatically uses its new path.
