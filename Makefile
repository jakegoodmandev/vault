db_reset:
	supabase db reset

db_start:
	supabase start

db_migrations_up:
	supabase migration up

db_migrations_make:
	supabase db diff

dash_gen_db_types:
	cd apps/dashboard && supabase gen types --local > src/lib/database.types.ts

dash_run:
	cd apps/dashboard && bun --bun run dev 

dash_format:
	cd apps/dashboard && bun --bun run format

dash_tests_run:
	cd apps/dashboard && bun --bun run test:e2e

dash_tests_run_ui:
	# The UI stalled when ran with the --bun flag, so we have to run it without that flag.
	cd apps/dashboard && bun run test:e2e:ui

