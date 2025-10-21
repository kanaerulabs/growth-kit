---
description: Generate a copy-pastable X thread from any content source
argument-hint: <input> [lang]
tags: [x, social, blog, thread, i18n]
---

Generate a copy-pastable X thread from any content source - blog posts, articles, PDFs, URLs, or plain text.

**Usage:** `$ARGUMENTS`

**Process:**

1. **Parse Input Arguments**
   - Extract content input and optional language parameter
   - Examples:
     - `2025-10-06-my-post` (slug only, default English)
     - `2025-10-06-my-post ja` (slug with Japanese)
     - `path/to/article.md` (file path)
     - `https://myblog.com/post` (URL)
     - `docs/whitepaper.pdf en` (PDF with language)

2. **Universal Input Detection**

   **If input looks like a file path** (contains `/` or file extension):
   - Use Read tool to check if file exists
   - Detect format by extension:
     - `.md` / `.mdx` → Parse markdown with frontmatter (extract title, description, body, metadata)
     - `.pdf` → Inform user PDF parsing is limited, suggest converting to markdown first
     - `.docx` → Inform user DOCX parsing is limited, suggest converting to markdown first
     - `.html` → Read and extract main content, strip HTML tags
     - `.txt` → Read as plain text
     - `.json` → Parse JSON and extract relevant fields
   - Extract: title, description, body content, metadata

   **If input looks like a URL** (starts with `http://` or `https://`):
   - Use WebFetch tool to retrieve the page
   - Prompt: "Extract the main article content, title, and description from this page"
   - Parse and clean the text

   **If input is a slug** (no `/` and no protocol):
   - Search codebase using Glob: `**/*${input}*.md`
   - Common patterns to check:
     - `src/content/blog/posts/{en,ja}/*${input}*.md`
     - `content/blog/*${input}*.md`
     - `posts/*${input}*.md`
     - `blog/*${input}*.md`
   - If language specified, prioritize matching language folder
   - Use Read tool to parse markdown file with frontmatter

3. **Determine Language** (default: English):
   - If user explicitly specifies "ja" → Japanese
   - If user explicitly specifies "en" → English
   - If file path contains `/ja/` → Japanese
   - If content appears to be in Japanese → Japanese
   - Otherwise → English

4. **Generate engaging X thread** in the target language:
   - **For English**: Follow Kanaeru Labs' X voice (see guidelines below)
   - **For Japanese**: Use professional yet accessible Japanese tone
   - Use actual blog content and key points
   - Make it contextual and intelligent, not template-based

5. **Generate the thread directly** using Claude's built-in capabilities:
   - Read the blog content using Read tool
   - Extract key insights and stats from the content
   - Create engaging thread following the guidelines below
   - Validate character counts (max 280 per post)
   - **PURE CLAUDE - NO external scripts, NO npm, NO dependencies**

6. **Display the generated thread** to the user in terminal:
   - Show all posts with character counts
   - Show total thread length (e.g., "6 posts")
   - Format for easy copy-pasting

7. **Create HTML preview file** using Write tool:
   - **IMPORTANT**: Check if file exists first: `ls -la x-thread-[LANG].html 2>&1`
   - If file exists, use Read tool first (even just 1 line): `Read('x-thread-[LANG].html', limit=1)`
   - Then use Write tool to create/update: `x-thread-[LANG].html` in user's current directory
   - Include all thread posts with "Copy Post" buttons
   - Use X branding (black theme)
   - Use Bash tool to open: `open x-thread-[LANG].html && open https://x.com/compose/post`
   - Works in ANY repo type (Python, Rust, Go, etc.)

---

## X Thread Guidelines

### Thread Structure (5-8 tweets):

1. **Hook Tweet** (Tweet 1/X)
   - Grab attention with a contrarian statement, stat, or bold claim
   - Don't give away everything - create curiosity
   - NO hashtags or links in first tweet (better algorithm reach)
   - Max 280 chars including thread indicator

2. **Problem/Context Tweets** (Tweets 2-3/X)
   - Set up the problem or context
   - Use specific data points from the blog
   - Keep each tweet to ONE idea
   - Max 280 chars each

3. **Insight Tweets** (Tweets 4-6/X)
   - Share 3-5 key insights from the blog
   - Use bullet points (•) or numbered lists
   - Include specific examples or stats
   - Make each tweet self-contained
   - Max 280 chars each

4. **CTA Tweet** (Final tweet)
   - Link to the full article (auto-detect from blog structure or use: https://www.kanaeru.ai/blog/[SLUG])
   - Simple CTA: "Read the full guide:" or "Full breakdown:"
   - Can include 2-3 relevant hashtags here
   - Encourage engagement: "What's your take?"
   - **Note**: For non-kanaeru blogs, omit URL or use placeholder "[BLOG URL]"

---

## Writing Style Guidelines

**Tone:**
- Conversational but authoritative
- Use "you" to make it personal
- Short sentences for readability
- Active voice preferred

**Formatting:**
- Use line breaks for readability
- Emojis sparingly (max 1-2 per tweet)
- Numbers/stats for credibility
- Avoid jargon unless necessary

**Thread Numbering:**
- Include "(1/6)" style numbering in EVERY tweet
- Count MUST be accurate
- Place at the end of each tweet

**Character Limits:**
- Each post: MAX 280 characters (including thread number)
- Account for URL shortening: URLs = 23 chars on X
- Leave buffer of 10-15 chars for safety

---

## Example English Thread Structure

```
Tweet 1/6:
AI agents can generate 1,000 lines of code in 60 seconds.

But humans need 60 minutes to review it.

This is the new bottleneck in software development that nobody's talking about. (1/6)

Tweet 2/6:
88% of senior executives plan to increase AI budgets in 2025.

Yet fewer than 45% are rethinking their operating models.

The result? AI-generated "workslop" that creates 2 hours of rework per instance. (2/6)

Tweet 3/6:
We've identified four dominant build models in the AI era:

• Traditional development (slow)
• AI-assisted coding (faster)
• Spec-Driven Development (clear)
• Review-Driven Design (optimal)

Most teams are stuck between 1 and 2. (3/6)

Tweet 4/6:
Review-Driven Design (RDD) flips the script:

Instead of optimizing for coding speed, optimize for REVIEW speed.

RDD code can be reviewed 10x faster: 60 mins → 6 mins.

That's where the real productivity gains hide. (4/6)

Tweet 5/6:
The gap between AI adopters and AI adapters is widening:

Adopters: Use AI tools
Adapters: Transform their entire delivery model

One is incrementally faster.
The other is fundamentally different. (5/6)

Tweet 6/6:
Full breakdown of all four build models, the hidden economics, and why review speed is the new bottleneck:

https://www.kanaeru.ai/blog/2025-10-06-choosing-your-build-model-agent-era-rdd-wins

Which approach is your team using? (6/6)

#AI #SoftwareDevelopment #DevOps
```

---

## Japanese Thread Guidelines (日本語スレッドのガイド)

**Tone & Style:**
- Professional yet accessible (です・ます調 or だ・である調)
- Technical content with clear explanations
- Less formal than LinkedIn, more conversational
- Use technical terms in English where appropriate

**Thread Structure:**
- Same 5-8 post structure as English
- Use emojis more liberally (Japanese X culture)
- Include article link in final post
- Hashtags in English (better reach)

**Example Japanese Hook:**
```
AIエージェントは60秒で1,000行のコードを生成できます。

でも人間がそれをレビューするには60分かかります。

これが2025年のソフトウェア開発における新しいボトルネックです。 (1/6)
```

---

## Thread Generation Checklist

Generate X thread that:
- ✅ Starts with an attention-grabbing hook (no links/hashtags)
- ✅ Maintains one clear idea per tweet
- ✅ Stays under 280 chars per tweet (including thread number)
- ✅ Uses actual insights/stats from the blog post
- ✅ Numbers tweets correctly (1/6, 2/6, etc.)
- ✅ Includes blog URL only in final tweet
- ✅ Ends with engagement question
- ✅ Uses line breaks for readability
- ✅ Adds relevant hashtags (2-4) only in final tweet
- ✅ Is immediately copy-pastable

**IMPORTANT**: Read the blog post content to extract real insights, not generic placeholders!

---

## Example Flow

### English Thread Example:
User: "Create X thread for 2025-10-06-production-ai-agents-langchain"

1. Read `src/content/blog/posts/en/2025-10-06-production-ai-agents-langchain.md`
2. Extract key insights from the actual content
3. Generate engaging 6-7 post thread directly (using Claude's LLM)
4. Create HTML preview file: `x-thread-en.html` (using Write tool)
5. Open preview and X.com (using Bash: `open x-thread-en.html && open https://x.com/compose/post`)
6. Display formatted thread with character counts
7. Provide copy-paste instructions

### Japanese Thread Example:
User: "Create X thread for 2025-10-06-production-ai-agents-langchain ja"

1. Detect language: Japanese (ja)
2. Read `src/content/blog/posts/ja/2025-10-06-production-ai-agents-langchain.md`
3. Extract key insights from the Japanese blog content
4. Generate Japanese thread directly (using Claude's LLM)
5. Create HTML preview file: `x-thread-ja.html` (using Write tool)
6. Open preview and X.com (using Bash)
7. Display formatted thread in Japanese with character counts
8. Provide copy-paste instructions

---

## Output Format

The script should output in this format:

```
═══════════════════════════════════════════════════════════════
✅ X Thread Generated & Browser Tabs Opened!
═══════════════════════════════════════════════════════════════

📄 Blog: [Blog Title]
🧵 Thread Length: 6 posts
🌐 Language: English 🇺🇸

📋 NEXT STEPS (Super Simple):
  1️⃣ HTML preview opened with "Copy Post" buttons
  2️⃣ X.com opened in new tab for posting
  3️⃣ Click "Copy Post" for each post
  4️⃣ Paste into X and create your thread

─────────────────────────────────────────────────────────────

📝 POST 1/6 (267 chars)
─────────────────────────────────────────────────────────────
[Post content here...]

─────────────────────────────────────────────────────────────

📝 POST 2/6 (245 chars)
─────────────────────────────────────────────────────────────
[Post content here...]

[... etc for all posts ...]

═══════════════════════════════════════════════════════════════
⚡ QUICK POSTING OPTIONS:
═══════════════════════════════════════════════════════════════

Option 1: Use HTML Preview (Recommended)
  ↳ Click "Copy Post" buttons in the HTML file
  ↳ Paste each post on X

Option 2: Manual Copy from Terminal
  ↳ Copy each post from above
  ↳ Post to X one by one

Option 3: X Thread Composer
  ↳ Copy entire thread at once
  ↳ X will auto-split at line breaks!

💡 PRO TIP: The HTML preview makes posting 10x faster!

═══════════════════════════════════════════════════════════════
```

---

## HTML Preview Template

After displaying the thread in the terminal, create an HTML file for easy copying:

**File Location:** `x-thread-en.html` or `x-thread-ja.html` in project root

**HTML Structure:**
- Clean, modern design with X branding (black color scheme)
- Each post in its own card with:
  - Post number badge (1/7, 2/7, etc.)
  - Post content (preserving line breaks)
  - Character count
  - "Copy Post" button that copies to clipboard
- Instructions section at bottom
- Responsive design for mobile/desktop

**After creating the file:**
```bash
open x-thread-[LANG].html
```

This opens the HTML file in the user's default browser for easy copying.
