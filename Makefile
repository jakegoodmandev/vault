db_reset:
	supabase db reset

db_start:
	supabase start

db_migrations_up:
	supabase migration up

dashboard_run:
	cd apps/dashboard && bun --bun run dev 

tests_run:
	cd apps/dashboard && bun --bun run test:e2e

tests_run_ui:
	# The UI stalled when ran with the --bun flag, so we have to run it without that flag.
	cd apps/dashboard && bun run test:e2e:ui