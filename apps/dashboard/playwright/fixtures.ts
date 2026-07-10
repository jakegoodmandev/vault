import { test as baseTest, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

import sql from './db.js';

export * from '@playwright/test';

const BASE_URL = 'http://localhost:3000';

export const test = baseTest.extend<{}, { workerStorageState: string }>({
  // Use the same storage state for all tests in this worker.
  storageState: ({ workerStorageState }, use) => use(workerStorageState),

  // Authenticate once per worker with a worker-scoped fixture.
  workerStorageState: [
    async ({ browser }, use) => {
      // Use parallelIndex as a unique identifier for each worker.
      const id = test.info().parallelIndex;
      const fileName = path.resolve(test.info().project.outputDir, `.auth/${id}.json`);

      if (fs.existsSync(fileName)) {
        // Reuse existing authentication state if any.
        await use(fileName);
        return;
      }

      // Important: make sure we authenticate in a clean environment by unsetting storage state.
      const page = await browser.newPage({ storageState: undefined });

      // Acquire a unique account, for example create a new one.
      // Alternatively, you can have a list of precreated accounts for testing.
      // Make sure that accounts are unique, so that multiple team members
      // can run tests at the same time without interference.
      const account = await acquireAccount(id);

      // Perform authentication steps. Replace these actions with your own.
      await page.goto(`${BASE_URL}/auth/login`);

      await page.locator('[id="email"]').fill(account.username);
      await page.locator('[id="password"]').fill(account.password);
      await page.getByRole('button', { name: /login/i }).click();

      // Wait until the page receives the cookies.
      //
      // Sometimes login flow sets cookies in the process of several redirects.
      // Wait for the final URL to ensure that the cookies are actually set.
      await expect(page.locator('[data-slot="avatar"]')).toBeVisible();
      // Alternatively, you can wait until the page reaches a state where all cookies are set.
      // await expect(
      //   page.getByRole('button', { name: 'View profile and more' })
      // ).toBeVisible();

      // End of authentication steps.

      await page.context().storageState({ path: fileName });
      await page.close();
      await use(fileName);
    },
    { scope: 'worker' },
  ],
});

async function acquireAccount(
  id: number
): Promise<{ username: string; password: string }> {
  const users = await sql`
    SELECT email
    FROM auth.users
    ORDER BY id asc
  `;

  if (users.length === 0) {
    throw new Error('No users found in the database. Please create a user first.');
  }

  if (id >= users.length) {
    throw new Error(
      `Not enough users in the database for parallel execution. Found ${users.length} users, but worker index is ${id}.`
    );
  }

  const user = users[id];

  // All passwords are seeded to 'password123' for testing purposes.
  return { username: user.email, password: 'password123' };
}
