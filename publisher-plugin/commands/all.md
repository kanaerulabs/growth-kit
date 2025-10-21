---
description: Generate content for all platforms (X, LinkedIn, Medium, Dev.to) from a single input
argument-hint: <input> [lang]
tags: [x, linkedin, medium, devto, social, blog, content, distribution]
---

Generate copy-pastable content for all social media platforms from a single input by running all publisher commands in parallel.

**Usage:** `$ARGUMENTS`

**Input:** Pass the same arguments you would use for individual commands - slug, file path, URL, etc.

---

## Process

1. **Parse Arguments and Language Detection**
   - Extract the full arguments string: `$ARGUMENTS`
   - Detect language from arguments:
     - If ends with `ja` → Japanese content
     - If ends with `en` → English content
     - If ends with `both` → Generate for both languages
     - Default → English if no language specified
   - Example: `2025-10-06-my-post ja` → Japanese version

2. **Run All Publisher Commands SEQUENTIALLY**

   **CRITICAL:** Execute commands ONE AT A TIME, waiting for each to complete before starting the next:

   ```
   // Step 1: Run X thread generation
   SlashCommand("/publisher:x $ARGUMENTS")
   // Wait for completion, then...

   // Step 2: Run LinkedIn post generation
   SlashCommand("/publisher:linkedin $ARGUMENTS")
   // Wait for completion, then...

   // Step 3: Run Medium article generation
   SlashCommand("/publisher:medium $ARGUMENTS")
   // Wait for completion, then...

   // Step 4: Run Dev.to RSS generation
   SlashCommand("/publisher:devto")
   ```

   **IMPORTANT:** Run commands in SEPARATE messages, waiting for each command to fully complete before proceeding to the next. This ensures stability and prevents resource contention.

3. **Auto-Open Browser Tabs for Immediate Action**

   All commands will process the input and automatically open the necessary tabs:
   - **X**: Opens HTML preview with copy buttons for each post + X.com compose
   - **LinkedIn**: Opens draft in LinkedIn feed + browser tab to review
   - **Medium**: Opens HTML with one-click copy + Medium editor tab
   - **Dev.to**: Opens Dev.to settings page + generates RSS file

4. **Summary with Clear Next Actions**

   Once all commands complete sequentially, provide a detailed action summary:
   ```
   ✅ ALL PLATFORMS GENERATED SEQUENTIALLY
   ════════════════════════════════════════

   📱 X Thread
      ↳ HTML preview opened with thread
      ↳ X.com compose page opened in browser
      ↳ Click "Copy Post" buttons to copy each post
      ↳ Post to X using thread composer

   💼 LinkedIn Post
      ↳ Draft created and LinkedIn opened
      ↳ Navigate to your drafts to review
      ↳ Add any final touches and click "Post"

   📝 Medium Article
      ↳ HTML preview opened with one-click copy
      ↳ Medium editor opened in new tab
      ↳ Click to copy entire article, then paste in Medium

   🔗 Dev.to RSS Feed
      ↳ RSS file generated: public/rss-devto.xml
      ↳ Settings page opened
      ↳ Add RSS URL to "Publishing from RSS" section

   ⚡ All browser tabs opened for immediate action!
   ```

---

## Example Usage

```bash
# Generate for all platforms (English - default)
/publisher:all 2025-10-13-my-post
/publisher:all 2025-10-13-my-post en

# Generate for all platforms (Japanese)
/publisher:all 2025-10-13-my-post ja

# Generate for BOTH languages simultaneously
/publisher:all 2025-10-13-my-post both

# From a file path (with language)
/publisher:all path/to/article.md ja

# From a URL (auto-detects language from content)
/publisher:all https://myblog.com/my-post
```

---

## Implementation Notes

- **Single source of truth:** Each platform command handles its own input detection and generation logic
- **Sequential execution:** Commands run one at a time to ensure stability and prevent resource contention
- **No duplication:** Changes to individual platform logic automatically apply when using `/publisher:all`
- **Extensibility:** Adding new platforms just requires adding another SlashCommand call in the sequence
