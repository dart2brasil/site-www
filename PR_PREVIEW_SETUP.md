# PR Preview Deployment Setup

This repository is configured to automatically deploy previews of pull requests to Firebase Hosting.

## How PR Previews Work

When you open or update a pull request to `main`:

1. **Build** - GitHub Actions builds the site using `dart run dash_site build`
2. **Deploy** - The built site is deployed to Firebase Hosting on a preview channel
3. **Comment** - A comment is automatically posted on the PR with a link to the live preview

Preview URLs follow this format:
```
https://transliteradu.web.app/?channel=pr-{PR_NUMBER}
```

## Configuration

### Workflows
- **File**: `.github/workflows/build.yml`
- **Triggers**: Pull requests to `main` branch and pushes to `main`
- **Key Jobs**:
  - `build` - Builds the site and checks for broken links
  - `firebase-deploy-preview` - Deploys to Firebase preview channels (PR only)

### Firebase Configuration
- **Firebase Project**: Configured in `.firebaserc` (default: `transliteradu`)
- **Hosting**: Configured in `firebase.json`
  - Public directory: `_site`
  - Clean URLs enabled (removes .html extension)
  - Redirects and headers configured

### Required GitHub Secrets

For PR previews to work, configure these secrets in your GitHub repository:

1. `FIREBASE_SERVICE_ACCOUNT` - Firebase service account JSON
   - Generate from Firebase Console → Project Settings → Service Accounts
   - Copy the entire JSON as the secret value

2. `FIREBASE_PROJECT_ID` - Your Firebase project ID
   - For this repo: `transliteradu`

## Setting Up Secrets

1. Go to: `Settings` → `Secrets and variables` → `Actions`
2. Click `New repository secret`
3. Add the secrets listed above

## Testing Previews

1. Create a test PR with any changes
2. The workflow will run automatically
3. Once complete, a comment will appear with the preview URL
4. Click the link to see your changes live

## Build Process

The site is built using:
- **Dart**: `dart run dash_site build`
- **Build directory**: Root workspace (pubspec.yaml workspaces)
- **Output**: `_site/` directory

## Troubleshooting

- Check the workflow runs in the `Actions` tab
- View logs to diagnose build or deployment failures
- Ensure secrets are properly configured
- Verify Firebase service account has Hosting deploy permissions
