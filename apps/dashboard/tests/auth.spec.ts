import { test } from '../playwright/fixtures';
import { test as unauthenticatedTest, expect } from '@playwright/test';

unauthenticatedTest.describe('unauthenticated user', () => {
  unauthenticatedTest('can access sign up page', async ({ page }) => {
    await page.goto('/auth/sign-up');

    await expect(
      page.locator('[data-slot="card-title"]').getByText('Sign up')
    ).toBeVisible();
  });

  unauthenticatedTest('can access login page', async ({ page }) => {
    await page.goto('/auth/login');

    await expect(
      page.locator('[data-slot="card-title"]').getByText('Login')
    ).toBeVisible();
  });

  unauthenticatedTest(
    'gets redirected to login page when accessing protected route #1',
    async ({ page }) => {
      await page.goto('/');
      await expect(page).toHaveURL('/auth/login');
    }
  );

  unauthenticatedTest(
    'gets redirected to login page when accessing protected route #2',
    async ({ page }) => {
      await page.goto('/dashboard');
      await expect(page).toHaveURL('/auth/login');
    }
  );
});

test.describe('authenticated user', () => {
  test('can access dashboard', async ({ page }) => {
    await page.goto('/dashboard');
    await expect(page).toHaveURL('/dashboard');
  });

  test('can sign out', async ({ page }) => {
    await page.goto('/dashboard');

    page.locator('[data-slot="sidebar-footer"]').click();
    page.getByText('Sign out').click();

    await expect(page).toHaveURL('/auth/login');
  });
});
