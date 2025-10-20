---
description: Create a LinkedIn post from any content source
argument-hint: <input> [lang] [custom-file-path]
tags: [linkedin, social, blog, i18n]
---

Create a LinkedIn post from any content source - blog posts, articles, PDFs, URLs, or plain text.

**Usage:** `$ARGUMENTS`

**Optional custom file attachment:**
```bash
# Auto-generate PDF from ALL blog diagrams (default)
/publisher:linkedin my-post

# Attach your own image or PDF
/publisher:linkedin my-post en path/to/image.png
/publisher:linkedin my-post en path/to/report.pdf
```

**Media attachment (zero dependencies!):**
- **With Pillow**: Generates PDF from all diagrams → single file
- **Without Pillow**: Uploads all diagrams as separate images → works everywhere!
- **Custom file**: Just provide the path → always works
- **No install required** for the fallback option!

**IMPORTANT:** LinkedIn's "Little Text Format" treats certain characters as special syntax.
The following characters are automatically escaped: `( ) { } [ ] < > @ | ~ _ * #`

**DO NOT manually escape these characters in your commentary** - Claude handles escaping automatically using bash/sed.
Pass raw text with parentheses, hashtags, etc. directly.

**Process:**

1. **Parse Input Arguments**
   - Extract content input, optional language parameter, and optional custom file path
   - Examples:
     - `2025-10-06-my-post` (slug only, default English)
     - `2025-10-06-my-post ja` (slug with Japanese)
     - `2025-10-06-my-post en path/to/custom.png` (with custom file)
     - `path/to/article.md` (file path)
     - `https://myblog.com/post` (URL)

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

4. **Generate engaging LinkedIn commentary** in the target language:
   - **For English**: Follow professional thought leadership voice (see examples below)
   - **For Japanese**: Use professional Japanese business tone (敬語), include article link
   - Use actual blog content and key points
   - Make it contextual and intelligent, not template-based

5. **Handle file attachment**:

   **If custom file path provided** (third argument):
   - Use the specified file path (e.g., `path/to/image.png` or `path/to/report.pdf`)
   - Verify file exists using Read tool
   - Supported formats: `.png`, `.jpg`, `.jpeg`, `.pdf`
   - Use this file for LinkedIn media upload

   **If no custom file specified** (default behavior):
   - Auto-detect blog diagrams:
     - English: `public/diagrams/[SLUG]-0-en-light.png`
     - Japanese: `public/diagrams/[SLUG]-0-ja-light.png`
   - Script will auto-generate PDF from diagrams if found
   - Commentary MUST include article URL when diagrams exist

6. **Create the draft** using pure Bash + curl:

   **Truly Universal**: Works in Python, Rust, Go, JavaScript - ANY repo type!
   **Requirements**: Only `bash` and `curl` (standard on all systems)

   **Process**:
   a. Check if `.env` file exists (use Read tool):
      - Look for `LINKEDIN_CLIENT_ID`, `LINKEDIN_CLIENT_SECRET`, `LINKEDIN_ACCESS_TOKEN`
      - If missing, guide user to create `.env` from `.env.example`

   b. If no access token, help user get one:
      - Build OAuth URL with proper parameters
      - Tell user to visit URL and authorize
      - User will paste back the authorization code
      - Exchange code for token using Bash + curl
      - Update `.env` file using Edit tool to save token

   c. Prepare commentary for JSON (pure bash):
      ```bash
      # Save commentary to temp file first
      cat > /tmp/linkedin-commentary-raw.txt << 'COMMENTARYEOF'
[YOUR COMMENTARY TEXT HERE]
COMMENTARYEOF

      # Escape for JSON only (quotes and backslashes)
      # DO NOT escape LinkedIn characters - they work fine in API!
      sed 's/\\/\\\\/g; s/"/\\"/g' /tmp/linkedin-commentary-raw.txt > /tmp/linkedin-json-ready.txt

      # Read escaped text
      COMMENTARY_TEXT=$(cat /tmp/linkedin-json-ready.txt)
      ```
      **IMPORTANT**: Only escape for JSON (quotes, backslashes).
      LinkedIn character escaping `( ) #` etc. is NOT needed for the REST API - only for UI input!

   c2. Prepare media file (PDF from all diagrams OR custom file):
      ```bash
      # Determine which file to upload (custom file takes precedence)
      MEDIA_FILE=""
      MEDIA_URN=""
      FILE_TYPE=""

      # Check if user provided custom file path (3rd argument)
      if [ -n "$CUSTOM_FILE_PATH" ] && [ -f "$CUSTOM_FILE_PATH" ]; then
        MEDIA_FILE="$CUSTOM_FILE_PATH"
        FILE_TYPE=$(echo "$CUSTOM_FILE_PATH" | grep -o '\.[^.]*$')
        echo "📎 Using custom file: $CUSTOM_FILE_PATH"

      # Otherwise, generate PDF from ALL blog diagrams
      else
        # Find all diagrams for this blog post
        DIAGRAM_COUNT=$(ls public/diagrams/${SLUG}-*-${LANG}-light.png 2>/dev/null | wc -l)

        if [ "$DIAGRAM_COUNT" -gt 0 ]; then
          echo "📊 Found $DIAGRAM_COUNT blog diagrams"

          # Check if Python + Pillow available
          if command -v python3 >/dev/null 2>&1 && python3 -c "from PIL import Image" 2>/dev/null; then
            # Generate PDF from all diagrams
            echo "📄 Generating PDF from $DIAGRAM_COUNT diagrams..."
            PDF_PATH="/tmp/${SLUG}-diagrams.pdf"

            python3 -c "
from PIL import Image
from pathlib import Path
images = [Image.open(str(f)).convert('RGB') for f in sorted(Path('public/diagrams').glob('${SLUG}-*-${LANG}-light.png'))]
if images:
    images[0].save('$PDF_PATH', save_all=True, append_images=images[1:])
    print('✅ PDF created with $DIAGRAM_COUNT pages')
" 2>/dev/null

            if [ -f "$PDF_PATH" ]; then
              MEDIA_FILE="$PDF_PATH"
              FILE_TYPE="pdf"
            fi

          else
            # Pillow not available - ask user
            echo ""
            echo "📦 Python Pillow not installed (needed for PDF generation)"
            echo ""
            echo "Options:"
            echo "  1. Install Pillow now: pip install Pillow (then rerun command)"
            echo "  2. Skip - upload all $DIAGRAM_COUNT diagrams as separate images (works everywhere!)"
            echo ""

            # Use AskUserQuestion to get user choice
            # For now, default to uploading all images separately (no install needed)
            echo "⚡ Uploading all $DIAGRAM_COUNT diagrams as separate images..."
            MEDIA_FILE="multiple"
            FILE_TYPE="multiple-images"
          fi
        fi
      fi

      # Upload media (single file or multiple images)
      if [ "$FILE_TYPE" = "multiple-images" ]; then
        # Upload all diagrams separately (LinkedIn supports up to 9 images)
        echo "📤 Uploading $DIAGRAM_COUNT images to LinkedIn..."
        MEDIA_URNS=()
        INDEX=1

        IMAGES_JSON_ARRAY=""

        for img in public/diagrams/${SLUG}-*-${LANG}-light.png; do
          BASENAME=$(basename "$img" .png)
          echo "  [$INDEX/$DIAGRAM_COUNT] Uploading $BASENAME..."

          # Register upload
          REG_RESP=$(curl -s -X POST \
            "https://api.linkedin.com/rest/images?action=initializeUpload" \
            -H "Authorization: Bearer $TOKEN" \
            -H "LinkedIn-Version: 202506" \
            -H "X-Restli-Protocol-Version: 2.0.0" \
            -H "Content-Type: application/json" \
            -d "{\"initializeUploadRequest\": {\"owner\": \"$MEMBER_URN\"}}")

          UP_URL=$(echo "$REG_RESP" | grep -o '"uploadUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\u0026/\&/g')
          IMG_URN=$(echo "$REG_RESP" | grep -o '"image":"[^"]*"' | cut -d'"' -f4)

          if [ -n "$UP_URL" ] && [ -n "$IMG_URN" ]; then
            curl -s -X PUT "$UP_URL" -H "Authorization: Bearer $TOKEN" --upload-file "$img" >/dev/null 2>&1

            # Add to images array with id AND altText (required!)
            if [ -n "$IMAGES_JSON_ARRAY" ]; then
              IMAGES_JSON_ARRAY="${IMAGES_JSON_ARRAY},"
            fi
            IMAGES_JSON_ARRAY="${IMAGES_JSON_ARRAY}{\"id\":\"$IMG_URN\",\"altText\":\"Diagram $INDEX\"}"
            echo "    ✅ Uploaded"
          fi

          INDEX=$((INDEX + 1))
        done

        # Complete images array
        MEDIA_URN="[${IMAGES_JSON_ARRAY}]"
        echo "✅ All $DIAGRAM_COUNT images uploaded with altText!"

      elif [ -n "$MEDIA_FILE" ]; then
        # Single file upload
        case "$MEDIA_FILE" in
          *.pdf) API_ENDPOINT="documents"; URN_KEY="document" ;;
          *.png|*.jpg|*.jpeg) API_ENDPOINT="images"; URN_KEY="image" ;;
        esac

        echo "📤 Uploading $(basename $MEDIA_FILE)..."
        REG_RESP=$(curl -s -X POST \
          "https://api.linkedin.com/rest/${API_ENDPOINT}?action=initializeUpload" \
          -H "Authorization: Bearer $TOKEN" \
          -H "LinkedIn-Version: 202506" \
          -H "X-Restli-Protocol-Version: 2.0.0" \
          -H "Content-Type: application/json" \
          -d "{\"initializeUploadRequest\": {\"owner\": \"$MEMBER_URN\"}}")

        UP_URL=$(echo "$REG_RESP" | grep -o '"uploadUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\u0026/\&/g')
        MEDIA_URN=$(echo "$REG_RESP" | grep -o "\"${URN_KEY}\":\"[^\"]*\"" | cut -d'"' -f4)

        if [ -n "$UP_URL" ] && [ -n "$MEDIA_URN" ]; then
          curl -s -X PUT "$UP_URL" -H "Authorization: Bearer $TOKEN" --upload-file "$MEDIA_FILE" >/dev/null
          echo "✅ Uploaded!"
        else
          echo "⚠️  Upload failed"
          MEDIA_URN=""
        fi
      fi
      ```

   d. Create JSON payload with optional media (pure bash):
      ```bash
      # Escape newlines for JSON (replace \n with \\n)
      COMMENTARY_JSON=$(echo "$COMMENTARY_TEXT" | awk '{printf "%s\\n", $0}' | sed '$ s/\\n$//')

      # Build JSON based on media type
      if [[ "$MEDIA_URN" == "["* ]]; then
        # Multiple images (array format)
        cat > /tmp/linkedin-post.json << EOF
{
  "author": "$MEMBER_URN",
  "commentary": "$COMMENTARY_JSON",
  "visibility": "PUBLIC",
  "distribution": {"feedDistribution": "MAIN_FEED"},
  "content": {
    "multiImage": {
      "images": $(echo "$MEDIA_URN" | sed 's/"urn/"id":"urn/g' | sed 's/",/"},/g' | sed 's/]$/}]/')
    }
  },
  "lifecycleState": "DRAFT"
}
EOF
      elif [ -n "$MEDIA_URN" ]; then
        # Single media attachment
        cat > /tmp/linkedin-post.json << EOF
{
  "author": "$MEMBER_URN",
  "commentary": "$COMMENTARY_JSON",
  "visibility": "PUBLIC",
  "distribution": {"feedDistribution": "MAIN_FEED"},
  "content": {
    "media": {
      "id": "$MEDIA_URN"
    }
  },
  "lifecycleState": "DRAFT"
}
EOF
      else
        # Text-only post
        cat > /tmp/linkedin-post.json << EOF
{
  "author": "$MEMBER_URN",
  "commentary": "$COMMENTARY_JSON",
  "visibility": "PUBLIC",
  "distribution": {"feedDistribution": "MAIN_FEED"},
  "lifecycleState": "DRAFT"
}
EOF
      fi
      ```
      **Pure bash JSON creation** - handles single/multiple media or text-only!

   e. Post to LinkedIn using curl (Bash tool) **with error handling**:
      ```bash
      # Post to LinkedIn and capture response
      RESPONSE=$(curl -s -X POST https://api.linkedin.com/rest/posts \
        -H "Authorization: Bearer $TOKEN" \
        -H "LinkedIn-Version: 202506" \
        -H "X-Restli-Protocol-Version: 2.0.0" \
        -H "Content-Type: application/json" \
        -d @/tmp/linkedin-post.json)

      # Check for errors in response
      if echo "$RESPONSE" | grep -q '"status"'; then
        STATUS=$(echo "$RESPONSE" | grep -o '"status":[0-9]*' | cut -d':' -f2)
        if [ "$STATUS" -ge 400 ]; then
          echo "❌ LinkedIn API Error (Status: $STATUS):"
          echo "$RESPONSE" | grep -o '"message":"[^"]*"' | sed 's/"message":"//;s/"//'
          echo ""
          echo "💡 The post content was generated and saved to:"
          echo "   /tmp/linkedin-commentary.txt"
          echo ""
          echo "📋 You can copy it and post manually to LinkedIn"
          # Still open LinkedIn so user can post manually
          open https://www.linkedin.com/feed/
          exit 0
        fi
      fi

      echo "✅ LinkedIn draft created successfully!"
      ```

   f. Extract post ID from response using grep/sed (no jq needed!) - if successful

   g. Open LinkedIn feed using Bash tool: `open https://www.linkedin.com/feed/`

   **Note**: Pure bash/curl implementation - works ANYWHERE!

7. **Report results** to user with draft URL

---

## Professional LinkedIn Voice Guidelines

**Example post styles for thought leadership content:**

### Post 1 Style (No emojis originally, but use emojis now):
```
The Four Ways to Build Software in 2025 (And Why Most Are Getting It Wrong)

AI agents are revolutionizing software development, creating a multi-trillion-dollar market. Notably, 88% of senior executives plan to increase their AI budgets in 2025. However, a concerning reality persists: fewer than 45% are fundamentally rethinking their operating models.

This oversight leads to 41% of workers facing AI-generated "workslop"—content that seems polished but lacks depth—resulting in nearly two hours of rework for each instance.

In our latest deep-dive, we explore:

- The four dominant build models in the AI agent era
- Why Review-Driven Design (RDD) is a game-changer
- How Spec-Driven Development (SDD) removes ambiguity
- The hidden economics of AI development that many teams overlook
- Why review speed—not coding speed—is the new bottleneck

Key insight: AI agents can generate 1,000 lines of code in 60 seconds, but humans require 60 minutes to review it. RDD optimizes code for 10x faster human review, cutting that time down to just 6 minutes.

The disparity between AI adopters and AI adapters is significant. Adopters utilize AI tools, while adapters transform their entire delivery model.

Which one are you?

Read the full article here: [URL]

hashtag#AI hashtag#SoftwareDevelopment hashtag#AIAgents...
```

### Post 2 Style (With emojis):
```
Your users don't follow specifications. They enter emoji in name fields, submit forms 17 times in 3 seconds, and paste entire novels into comment boxes.

The question isn't "if" something will go wrong-it's "what" will go wrong, "when", and whether your tests caught it first.

Here's the uncomfortable truth: You can have 100% code coverage and still miss critical edge cases.

Code coverage measures which lines execute during tests-not which behaviors are validated or which edge cases are explored.

We've developed an edge case taxonomy after researching several production incidents that "shouldn't have happened":

1️⃣ Boundary Cases - MIN/MAX values, string lengths, date ranges
2️⃣ Null/Empty Cases - null, undefined, empty collections
3️⃣ Format Cases - SQL injection, XSS, Unicode/emoji, malformed data
4️⃣ State Cases - Race conditions, invalid transitions, timeouts
5️⃣ Implicit Requirements - The unstated assumptions stakeholders never document

Real war stories from production:
• Leap year bug: Payment system added 365 days. Worked perfectly until Feb 29, 2020
• Unicode email incident: Regex rejected müller@example.com
• Null pointer in prod: Function assumed cart always had items. Empty cart = crash

The breakthrough approach? "Review-Driven Design meets TDD":
✅ Write edge case tests BEFORE implementing (not after)
✅ Use constructor injection to make hidden dependencies testable
✅ Organize tests by edge case category (boundary, security, performance)
✅ Track edge case coverage, not just code coverage

Instead of:
❌ "Build us a user dashboard"

Think:
✅ "What happens if username is null?"
✅ "What if email contains SQL injection attempt?"
✅ "What if two users click submit simultaneously?"
✅ "What if the API times out mid-operation?"

This is the detective's mindset: asking "what could possibly go wrong?" before writing any production code.

Our comprehensive guide covers:
• The Red-Green-Refactor cycle optimized for edge case hunting
• Constructor injection patterns that make testing 10x easier
• Property-based testing techniques
• Real-world case studies with lessons learned
• Complete edge case checklist for production readiness

Because edge case testing isn't about paranoia-it's about "craftsmanship".

Read the full practitioner's guide: [URL]

hashtag#TDD hashtag#SoftwareTesting...
```

---

## Commentary Generation Checklist

Generate LinkedIn commentary that:
- ✅ Starts with the blog post title
- ✅ Opens with a hook that grabs attention (stats, contrarian statement, or problem)
- ✅ Includes "Here's the uncomfortable truth:" or similar contrarian angle
- ✅ Lists 3-5 key points from the ACTUAL blog content with emojis (🎯, 💡, ⚡, ✅)
- ✅ Adds a "Key insight:" with a specific quantitative or qualitative takeaway
- ✅ Includes a rhetorical question for engagement ("Which one are you?")
- ✅ Links to the full article: [BLOG_BASE_URL]/blog/[SLUG]
- ✅ Ends with engagement CTA ("Drop your thoughts below! 👇" or similar)
- ✅ Uses relevant hashtags (5-7 hashtags related to the content)
- ✅ Keeps professional but conversational tone
- ✅ Incorporates actual insights/stats from the blog post (not generic)

**IMPORTANT**: Read the blog post content to extract real insights, not generic placeholders!

---

## Japanese LinkedIn Voice Guidelines (日本語投稿のガイド)

For Japanese posts, use professional business Japanese with these characteristics:

**Tone & Style:**
- Use 敬語 (polite Japanese) but not overly formal
- Professional yet approachable (です・ます調)
- Technical content with clear explanations
- Avoid overly casual expressions

**Structure:**
- Start with the article title
- Lead with a compelling fact or insight
- Use bullet points with numbers (①②③) or emojis
- Include key technical points from the blog
- End with article link: 詳細はこちら: [BLOG_BASE_URL]/blog/[SLUG]
- Add relevant hashtags in English (LinkedIn convention)
- Include engagement CTA: ご意見をお聞かせください 💬

**Example Japanese Post Structure:**
```
[タイトル]

[引きつける統計データや問題提起]

本記事では、以下について解説します：

🎯 [ポイント1]
💡 [ポイント2]
⚡ [ポイント3]
✅ [ポイント4]

重要な洞察：[具体的な数値やqualitative takeaway]

詳細はこちら：[BLOG_BASE_URL]/blog/[SLUG]

ご意見をお聞かせください 💬

#LangChain #AIエージェント #ソフトウェア開発
```

---

## Example Flow

### English Post Example:
User: "Create LinkedIn draft for 2025-10-06-production-ai-agents-langchain"

1. Read `src/content/blog/posts/en/2025-10-06-production-ai-agents-langchain.md`
2. Extract key insights from the actual content
3. Generate contextual, intelligent English commentary
4. Check for LinkedIn credentials in `.env` (guide through OAuth if needed)
5. Use `curl` to create LinkedIn draft via REST API
6. Open LinkedIn in browser: `open https://www.linkedin.com/feed/`
6. Report with clear next actions:
   ```
   ✅ LinkedIn draft created and browser opened!

   Next Steps:
   1. LinkedIn is now open in your browser
   2. Look for the draft post (may be at top of feed)
   3. Review the auto-generated content
   4. Make any final edits
   5. Click "Post" when ready!

   Note: PDF with diagrams was automatically attached
   ```

### Japanese Post Example:
User: "Create LinkedIn draft for 2025-10-06-production-ai-agents-langchain ja"

1. Detect language: Japanese (ja)
2. Read `src/content/blog/posts/ja/2025-10-06-production-ai-agents-langchain.md`
3. Extract key insights from the Japanese blog content
4. Generate contextual Japanese commentary (敬語 style)
5. Check for LinkedIn credentials in `.env` (guide through OAuth if needed)
6. Use `curl` to create LinkedIn draft via REST API
7. Open LinkedIn in browser: `open https://www.linkedin.com/feed/`
7. Report with clear next actions:
   ```
   ✅ LinkedIn draft created! 🇯🇵 Browser opened!

   次のステップ:
   1. LinkedInがブラウザで開かれました
   2. 下書きを確認してください（フィードの上部にあります）
   3. 内容をレビューしてください
   4. 必要に応じて編集してください
   5. 準備ができたら「投稿」をクリック！

   注: ダイアグラム付きPDFは自動的に添付されています
   ```
