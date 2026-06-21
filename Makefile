reset_db:
	cd supabase && supabase db reset

start_db:
	cd supabase && supabase start

run_migrations:
	cd supabase && supabase migration up

run_dashboard:
	cd apps/dashboard && bun --bun run dev 