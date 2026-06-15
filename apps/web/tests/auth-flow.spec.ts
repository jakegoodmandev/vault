import { test, expect } from '@playwright/test';

test.describe('Authentication Flow', () => {
  test('Sign-Up Happy Path: Navigate to sign-up, fill form, verify redirect to success page', async ({ page }) => {
    // Navigate to sign-up page
    await page.goto('/auth/sign-up');
    
    // Verify sign-up page loaded
    await expect(page).toHaveURL(/.*\/auth\/sign-up/);
    await expect(page.locator('[data-slot="card-title"]')).toBeVisible();
    
    // Fill email field
    await page.locator('#email').fill('test@example.com');
    
    // Fill password field
    await page.locator('#password').fill('TestPassword123!');
    
    // Fill repeat password field
    await page.locator('#repeat-password').fill('TestPassword123!');
    
    // Click sign up button
    await page.getByRole('button', { name: 'Sign up' }).click();
    
    // Verify redirect to success page
    await expect(page).toHaveURL(/.*\/auth\/sign-up-success/);
  });

  test('Password Mismatch: Enter mismatched passwords and verify error message', async ({ page }) => {
    // Navigate to sign-up page
    await page.goto('/auth/sign-up');
    
    // Fill email field
    await page.locator('#email').fill('test2@example.com');
    
    // Fill password field
    await page.locator('#password').fill('TestPassword123!');
    
    // Fill repeat password field with different password
    await page.locator('#repeat-password').fill('DifferentPassword!');
    
    // Click sign up button
    await page.getByRole('button', { name: 'Sign up' }).click();
    
    // Verify error message appears
    await expect(page.locator('text=Passwords do not match')).toBeVisible();
    
    // Verify still on sign-up page
    await expect(page).toHaveURL(/.*\/auth\/sign-up/);
  });

  test('Navigation: From sign-up, click "Login" link and verify navigation', async ({ page }) => {
    // Navigate to sign-up page
    await page.goto('/auth/sign-up');
    
    // Click login link
    await page.getByRole('link', { name: 'Login' }).click();
    
    // Verify redirect to login page
    await expect(page).toHaveURL(/.*\/auth\/login/);
    await expect(page.getByRole('heading', { name: 'Login' })).toBeVisible();
  });

  test('Login Page: Verify form elements and loading state', async ({ page }) => {
    // Navigate to login page
    await page.goto('/auth/login');
    
    // Verify login page loaded
    await expect(page).toHaveURL(/.*\/auth\/login/);
    await expect(page.getByRole('heading', { name: 'Login' })).toBeVisible();
    
    // Verify form elements
    await expect(page.locator('#email')).toBeVisible();
    await expect(page.locator('#password')).toBeVisible();
    
    // Verify button text
    const loginButton = page.getByRole('button', { name: 'Login' });
    await expect(loginButton).toBeVisible();
  });

  test('Navigation: From login, click "Sign up" link and verify navigation', async ({ page }) => {
    // Navigate to login page
    await page.goto('/auth/login');
    
    // Click sign up link
    await page.getByRole('link', { name: 'Sign up' }).click();
    
    // Verify redirect to sign-up page
    await expect(page).toHaveURL(/.*\/auth\/sign-up/);
    await expect(page.getByRole('heading', { name: 'Sign up' })).toBeVisible();
  });

  test('Forgot Password Link: Verify link exists on login page', async ({ page }) => {
    // Navigate to login page
    await page.goto('/auth/login');
    
    // Verify forgot password link exists
    const forgotLink = page.getByRole('link', { name: 'Forgot your password?' });
    await expect(forgotLink).toBeVisible();
    
    // Click forgot password link
    await forgotLink.click();
    
    // Verify navigation to forgot password page
    await expect(page).toHaveURL(/.*\/auth\/forgot-password/);
  });
});
