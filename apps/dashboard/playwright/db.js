import { loadEnvConfig } from '@next/env';
import postgres from 'postgres';

loadEnvConfig(__dirname);

const sql = postgres(process.env.TEST_DB_URL);

export default sql;
