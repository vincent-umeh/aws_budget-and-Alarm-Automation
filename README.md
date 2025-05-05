## CI/CD Deployment

1. Set up GitHub Secrets/Variables:
   - `AWS_ACCESS_KEY_ID` + `AWS_SECRET_ACCESS_KEY`
   - `NOTIFICATION_EMAIL` (for alerts)
   - `BUDGET_AMOUNT` (in USD)

2. Merging to `main` triggers auto-deployment

3. Monitor workflows in [Actions tab](/.github/workflows/deploy.yml)