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

4. **Generate THREE versions** in the target language:

   **Version 1: Thread (5-8 posts)**
   - **For English**: Follow Kanaeru Labs' X voice (see guidelines below)
   - **For Japanese**: Use professional yet accessible Japanese tone
   - Break into digestible posts (max 280 chars each)

   **Version 2: Single Long (Premium)**
   - Structured format with clear sections
   - **For Japanese**: Use 【brackets】: 【とは】【誰のため】【主な特徴】【次にすべきこと】
   - **For English**: Use headers: **What it is:** **Who it's for:** **Key features:** **What to do next:**

   **Version 3: Single Short (~280 chars)**
   - Concise announcement
   - 2-3 key benefits with emojis
   - Links and hashtags

5. **Generate all three versions directly** using Claude's built-in capabilities:
   - Read the blog content using Read tool
   - Extract key insights and stats from the content
   - Create all 3 versions following the guidelines below
   - Validate character counts
   - **PURE CLAUDE - NO external scripts, NO npm, NO dependencies**
   - **APPLY HUMANIZATION** (see Humanization Guidelines below)

6. **Display all versions** to the user in terminal:
   - Show thread posts with character counts
   - Show single long version
   - Show single short version
   - Format for easy copy-pasting

7. **Create tri-format HTML preview file** using Write tool:
   - **IMPORTANT**: Check if file exists first: `ls -la x-thread-[LANG].html 2>&1`
   - If file exists, use Read tool first (even just 1 line): `Read('x-thread-[LANG].html', limit=1)`
   - Then use Write tool to create/update: `x-thread-[LANG].html` in user's current directory
   - **Include THREE tabs with tab switcher UI**:
     - **Tab 1: Thread** - 5-8 posts with individual "Copy Post" buttons
     - **Tab 2: Single Long** - Structured format with sections, one "Copy" button
     - **Tab 3: Single Short** - Concise version (~280 chars), one "Copy" button
   - Use X branding (black theme)
   - Tab switcher at top for easy navigation
   - Use Bash tool to open: `open x-thread-[LANG].html && open https://x.com/compose/post`
   - Works in ANY repo type (Python, Rust, Go, etc.)

   **User benefits:** Choose the format that fits their audience!

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

## Humanization Guidelines

**CRITICAL**: All generated content MUST sound human, not AI-generated. Apply the `/humanizer` skill principles:

### Banned Words List

Never use these AI-tell words:

**Significance inflation:** unprecedented, remarkable, groundbreaking, revolutionary, transformative, game-changing, paradigm-shifting, cutting-edge, state-of-the-art, best-in-class

**Empty intensifiers:** truly, deeply, incredibly, extremely, absolutely, fundamentally, significantly, dramatically, tremendously, overwhelmingly

**AI connector words:** Additionally, Moreover, Furthermore, Consequently, Nevertheless, Notwithstanding, Accordingly, Subsequently, Henceforth

**AI favorite verbs:** delve, utilize, leverage, optimize, streamline, facilitate, spearhead, synergize, revolutionize, empower

**Vague abstractions:** landscape, tapestry, ecosystem, paradigm, framework, infrastructure, methodology, holistic, comprehensive, robust

**Corporate filler:** crucial, pivotal, vital, essential, key, critical, paramount, instrumental, imperative, indispensable

**AI adjectives:** seamless, intuitive, innovative, dynamic, agile, scalable, sustainable, impactful, actionable, best-practice

### Banned Phrases List

Never use these constructions:

- "In a world where..."
- "At the end of the day..."
- "It goes without saying..."
- "Stands as a testament to..."
- "It's not just X, it's Y"
- "The fact of the matter is..."
- "In terms of..."
- "When it comes to..."
- "Take your X to the next level"
- "Unlock the power of..."
- "The future of X is here"
- "X is the new Y"
- "Experts agree that..."
- "Studies show that..." (without citation)
- "In today's fast-paced world..."
- "Now more than ever..."
- "Let's dive in..."
- "Without further ado..."
- "Here's the thing..."
- "The bottom line is..."

### Structural Rules

1. **Active voice only** - "We built this" not "This was built"
2. **Direct address** - Use "you" and "your" to speak to readers
3. **Short sentences** - Aim for 15 words or fewer on average
4. **No setup phrases** - Cut "In conclusion", "To summarize", "As mentioned"
5. **Specific over general** - Numbers, names, dates beat vague claims
6. **Simple verbs** - "is" beats "serves as", "has" beats "boasts", "shows" beats "demonstrates"

### Patterns to AVOID:

1. **Inflated significance** - Don't say "stands as a testament to", "pivotal moment", "game-changer"
2. **Promotional language** - Avoid "groundbreaking", "revolutionary", "stunning", "breathtaking"
3. **Vague attributions** - No "experts believe", "industry reports show" without specifics
4. **Superficial -ing phrases** - Remove "highlighting the importance of", "showcasing the potential"
5. **Rule of three abuse** - Don't force "innovation, inspiration, and industry insights"
6. **Em dash overuse** - Use sparingly, prefer commas or periods
7. **Sycophantic tone** - No "Great question!", "You're absolutely right!"
8. **Generic conclusions** - Cut "The future looks bright", "exciting times ahead"

### What TO DO:

- **Be specific** - Use actual numbers, names, dates from the content
- **Vary rhythm** - Mix short punchy sentences with longer ones
- **Have opinions** - React to facts, don't just report them
- **Add personality** - Let some edge or humor through when appropriate
- **Keep it concrete** - Replace vague claims with specific examples

### Before/After Examples:

❌ "This groundbreaking approach serves as a testament to innovation, ensuring developers accomplish goals efficiently"

✅ "This approach cuts review time from 60 minutes to 6. Beta testers shipped 3x faster."

❌ "It's not just about speed—it's about fundamentally transforming how we think about development"

✅ "Speed matters less than reviewability. Fast code that takes hours to review is slower than clear code."

❌ "In today's fast-paced world, it's crucial to leverage cutting-edge solutions"

✅ "Most teams waste 4 hours a day on code review. Here's how to fix that."

❌ "Let's dive into this comprehensive guide that will revolutionize your workflow"

✅ "This guide shows three techniques. The first one saved us 12 hours last week."

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

## Single Post Guidelines (Premium Accounts)

### Long Version - Structured Format

**For Japanese** - Use 【bracket sections】:
```
[Title] 🚀

【[Product]とは】
[2-3 sentence description]

【誰のため】
✅ [Target user 1]
✅ [Target user 2]
✅ [Target user 3]

【主な特徴】
• [Feature 1]
• [Feature 2]

【時間節約/メリット】
• [Metric 1]
• [Metric 2]

【次にすべきこと】
1. [Step 1]
2. [Step 2]

詳細: [Blog URL]
GitHub: [Repo URL]

#Hashtags
```

**For English** - Use clear headers:
```
[Title] 🚀

**What it is:**
[2-3 sentence description]

**Who it's for:**
✅ [Target user 1]
✅ [Target user 2]

**Key features:**
• [Feature 1]
• [Feature 2]

**Time savings:**
• [Metric 1]
• [Metric 2]

**What to do next:**
1. [Step 1]
2. [Step 2]

Full guide: [Blog URL]
GitHub: [Repo URL]

#Hashtags
```

### Short Version - Concise (~280 chars)

**Structure:**
- Title + emoji
- 1-line description
- 2-3 key benefits (emojis)
- Blog link
- 2-3 hashtags

**Japanese Example:**
```
[Product] v1.0 リリース🚀
[One-line description]
✅ [Benefit 1]
✅ [Benefit 2]
✅ [Benefit 3]
[URL]
#Hashtags
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
