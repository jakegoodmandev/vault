reset_db:
	cd supabase && supabase db reset

start_db:
	cd supabase && supabase start

run_dashboard:
	cd apps/dashboard && bun --bun run dev 