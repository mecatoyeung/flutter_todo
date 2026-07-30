# Taskwell

A Flutter to-do list manager.

flutter run -d chrome --dart-define-from-file=.env

## Architecture

- Flutter Web uses Supabase directly from the browser.
- Supabase provides PostgreSQL storage and REST API.
- No custom API server is required for GitHub Pages deployment.

## Local setup

1. Install dependencies:

	```bash
	flutter pub get
	```
2. Create a Supabase project.

3. In Supabase SQL Editor, run:

	```sql
	 create table if not exists public.todo_lists (
		 id text primary key,
		 name text not null
	 );

	 create table if not exists public.todo_items (
		 id text primary key,
		 list_id text not null references public.todo_lists(id) on delete cascade,
		 subject text not null,
		 description text not null default '',
		 date_mode text not null default 'none',
		 due_at timestamptz,
		 is_done boolean not null default false
	 );

	 alter table public.todo_lists enable row level security;
	 alter table public.todo_items enable row level security;

	 create policy "public_todo_lists_rw"
	 on public.todo_lists
	 for all
	 to anon
	 using (true)
	 with check (true);

	 create policy "public_todo_items_rw"
	 on public.todo_items
	 for all
	 to anon
	 using (true)
	 with check (true);
	```

4. Create a `.env` file from `.env.example`, then set `SITE_PASSWORD` to a
   strong password. This is required to unlock the site.

5. Run Flutter Web with the values in `.env`:

	```bash
	flutter run -d chrome --dart-define-from-file=.env
	```

## GitHub Pages deployment

Set these repository secrets:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SITE_PASSWORD`

The workflow injects them into `flutter build web` with `--dart-define`.

> **Important:** GitHub Pages only hosts static files. The password gate
> prevents casual access to the app UI, but the password is embedded in the
> downloaded web bundle and is not a security boundary. Use server-side
> authentication or an access proxy for sensitive data.

### One-time GitHub setup

1. Open the repository **Settings** -> **Pages**.
2. Under **Build and deployment**, set **Source** to **GitHub Actions**.
3. In **Settings** -> **Secrets and variables** -> **Actions**, add `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `SITE_PASSWORD`.
4. Push to `main` and wait for **Deploy Flutter web app to GitHub Pages**.

The app is published at https://todo.catoyeung.com/. The repository URL
https://mecatoyeung.github.io/flutter_todo/ redirects there.

The configured GitHub Pages custom domain serves the app from `/`, so the
workflow builds Flutter with `/` as its web base path.
