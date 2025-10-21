---
description: Set up Vercel Analytics and Speed Insights
argument-hint:
tags: [vercel, analytics, monitoring]
---

Set up essential Vercel integrations for a React/Vite project.

## Tasks

1. **Install Vercel Packages**
   - Install @vercel/analytics
   - Install @vercel/speed-insights

2. **Add Components to App**
   - Import Analytics and SpeedInsights from their respective packages
   - Add both components to the main App component (typically in src/App.tsx or src/main.tsx)
   - For React projects, use `/react` imports (not `/next`)

3. **Create vercel.json for SPA Routing**
   - Create vercel.json in project root
   - Add rewrite rules to serve index.html for all routes
   - This fixes 404 errors when accessing routes directly

4. **Verify Setup**
   - Check that both components are rendered in the app
   - Test that direct route access works without 404s

## Expected Output

After running this command, the project should have:
- Analytics tracking configured
- Speed Insights monitoring configured
- SPA routing properly configured for Vercel deployment
