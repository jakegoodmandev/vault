reset_db:
	supabase db reset

start_db:
	supabase start

run_migrations:
	supabase migration up

run_dashboard:
	cd apps/dashboard && bun --bun run dev 