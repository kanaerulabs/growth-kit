---
description: Convert any content source to Medium-ready format
argument-hint: <input>
---

Convert any content source to Medium-ready format. This command is **adaptive** - it works with any input format and blog structure.

**Usage:** `$ARGUMENTS`

## Phase 1: Universal Input Detection

**Parse Input:**
- Extract content input from `$ARGUMENTS`
- Examples:
  - `2025-10-06-my-post` (slug)
  - `path/to/article.md` (file path)
  - `https://myblog.com/post` (URL)

**Detect and Load Content:**

**If input looks like a file path** (contains `/` or file extension):
- Use Read tool to load the file
- Detect format by extension:
  - `.md` / `.mdx` → Parse markdown with frontmatter
  - `.pdf` → Inform user PDF parsing is limited, suggest markdown
  - `.html` → Extract main content, strip HTML tags
  - `.txt` → Read as plain text
  - `.json` → Parse and extract relevant fields

**If input looks like a URL** (starts with `http://` or `https://`):
- Use WebFetch tool to retrieve the page
- Extract main article content, title, and description
- Parse and clean the text

**If input is a slug** (no `/` and no protocol):
- Search codebase using Glob: `**/*${input}*.md`
- Common blog locations:
  - `src/content/blog/posts/**/*${input}*.md`
  - `content/blog/*${input}*.md`
  - `posts/*${input}*.md`
  - `blog/*${input}*.md`
- Use Read tool to parse found markdown file

**Discover Blog Structure (if slug or file path):**
Explore the codebase to understand:
- 📁 Where are markdown files stored?
- 📋 What frontmatter format is used?
- 🖼️ Where are images/diagrams stored?
- 🎨 How are images referenced? (relative paths, absolute URLs, picture elements?)
- 🔗 What's the blog post URL structure?

**For URLs:** Extract and use the content as-is, skip blog structure discovery.

## Phase 2: Create Conversion Script

Write a **custom TypeScript conversion script** that handles their specific structure.

### Required Outputs (Universal Medium Best Practices):

**1. Image Handling - Upload Markers (CRITICAL)**
```typescript
// Medium strips base64 and external URLs fail
// Solution: Add clear upload marker for FIRST image only
// IMPORTANT: Only include the FIRST image from the blog post
return `\n\n---\n\n**📊 [UPLOAD IMAGE HERE: ${altText}]**\n\n*File: \`${relPath}\`*\n\n---\n\n`;
```

**2. References Format - Paragraphs Not Lists**
```typescript
// Medium adds blank numbers in lists
// Solution: Format as individual paragraphs
references.forEach(ref => {
  output += `\n\n**[${ref.number}]** ${ref.content}`;
});
```

**3. Footnotes - Inline Citations**
```typescript
// Convert [^1] to inline: [Author, Year, Source]
text.replace(/\[\^(\d+)\]/g, (match, num) => {
  return ` [${footnotes[num]}]`;
});
```

**4. Preview HTML with One-Click Copy**
```typescript
// Create HTML with simple one-click copy functionality
const previewHTML = generateOneClickCopyHTML(content);
fs.writeFileSync(previewPath, previewHTML);

// Auto-open in browser
exec(`${openCommand} "${previewPath}"`);

// Also open Medium editor
exec(`${openCommand} "https://medium.com/new-story"`);
```

**5. Attribution Footer - Specific URL**
```typescript
// Link to SPECIFIC blog post, not homepage
const blogPostURL = `${baseURL}/blog/${slug}`;
html += `<p><em>Originally published at <a href="${blogPostURL}">${siteName}</a></em></p>`;
```

**6. Clean HTML Conversion**
```typescript
// Use marked.js with:
marked.setOptions({
  gfm: true,
  breaks: false,
  headerIds: false,
  mangle: false
});
```

### One-Click Copy HTML Template

Generate an HTML with beautiful, simple one-click copy functionality:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Medium Article - One Click Copy</title>
  <style>
    /* Modern gradient background */
    body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }

    /* Big prominent copy button */
    .copy-button {
      background: #03a87c;
      color: white;
      padding: 15px 40px;
      border-radius: 30px;
      font-size: 18px;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.3s;
    }

    .copy-button:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(3,168,124,0.3);
    }

    /* Content box is clickable */
    .content-box {
      background: white;
      padding: 40px;
      border-radius: 12px;
      cursor: pointer;
      position: relative;
    }

    .content-box::before {
      content: "Click anywhere to copy";
      position: absolute;
      top: 10px;
      right: 10px;
      background: #f0f0f0;
      padding: 5px 10px;
      border-radius: 5px;
      font-size: 12px;
    }

    /* Success notification */
    .status-message {
      position: fixed;
      top: 20px;
      left: 50%;
      transform: translateX(-50%);
      background: #4caf50;
      color: white;
      padding: 15px 30px;
      border-radius: 30px;
      opacity: 0;
      transition: opacity 0.3s;
    }

    .status-message.show { opacity: 1; }
  </style>
</head>
<body>
  <div class="header">
    <button class="copy-button" onclick="copyContent()">
      📋 Copy Article to Clipboard
    </button>
    <p>Or click anywhere in the content box below</p>
  </div>

  <div class="content-box" onclick="copyContent()">
    <!-- Article content here -->
  </div>

  <div class="status-message" id="statusMessage">
    ✅ Content copied to clipboard!
  </div>

  <script>
    function copyContent() {
      const content = document.querySelector('.article-content').innerText;
      navigator.clipboard.writeText(content).then(() => {
        document.getElementById('statusMessage').classList.add('show');
        setTimeout(() => {
          document.getElementById('statusMessage').classList.remove('show');
        }, 3000);
      });
    }
  </script>
</body>
</html>
```

### Script Template Structure:

```typescript
import fs from 'fs';
import path from 'path';
import { marked } from 'marked';

const BLOG_BASE_URL = 'USER_PROVIDED_URL';

interface BlogMetadata {
  title: string;
  description: string;
  // ... detected fields
}

function parseBlogPost(filePath: string) {
  // Parse their specific frontmatter format
}

function convertImages(markdown: string, imagePath: string) {
  // Handle THEIR image format
  // Always output: upload markers
}

function formatReferences(markdown: string) {
  // Extract references section
  // Always output: paragraphs with [N] prefix
}

function convertToMedium(markdown: string, slug: string) {
  // Apply all universal fixes
  // Return clean HTML
}

function generatePreviewHTML(content: string, metadata: BlogMetadata) {
  return `<!DOCTYPE html>
<html>
<head>
  <title>Medium Preview: ${metadata.title}</title>
  <style>/* Clean, readable styling */</style>
</head>
<body>
  <div class="instructions">
    <h2>📋 How to Copy to Medium</h2>
    <ol>
      <li>Select all (Cmd/Ctrl+A)</li>
      <li>Copy (Cmd/Ctrl+C)</li>
      <li>Paste into Medium editor (Cmd/Ctrl+V)</li>
      <li>Upload images at markers</li>
      <li>Delete marker text after uploading</li>
      <li>Publish!</li>
    </ol>
  </div>
  <div id="content">${content}</div>
</body>
</html>`;
}

async function main() {
  // Parse blog post with their structure
  // Convert with universal Medium fixes
  // Generate preview and auto-open
}
```

## Phase 3: Execute & Guide

1. **Run the generated script** OR **Create HTML directly with Write tool**
   - If using Write tool directly for preview HTML:
     - **IMPORTANT**: Check if `medium-article-[LANG].html` exists first: `ls -la medium-article-[LANG].html 2>&1`
     - If exists, use Read tool first (even just 1 line): `Read('medium-article-[LANG].html', limit=1)`
     - Then use Write tool to create/update the file
2. **Verify preview opens** in browser
3. **Provide instructions:**
   - How many images to upload
   - Where each diagram file is located
   - Copy-paste workflow

## Critical Success Factors

✅ **Image markers must be clear** - User needs exact file paths
✅ **References as paragraphs** - Avoid Medium's numbered list bugs
✅ **Preview auto-opens** - Streamlined workflow
✅ **Specific blog URL** - Not just homepage
✅ **Clean formatting** - No extra blank lines or artifacts

## Testing Checklist

After conversion, verify:
- [ ] Preview HTML opens automatically
- [ ] All images have upload markers with file paths
- [ ] References section has no blank numbers
- [ ] Footer links to specific blog post URL
- [ ] Footnotes converted to inline citations
- [ ] Code blocks preserved
- [ ] No HTML artifacts (picture tags removed, etc.)

## Example Interaction

```
User: /convert-to-medium
You: Which blog post would you like to convert? (provide path or slug)
User: src/posts/2024-01-15-my-post.md
You: What's your blog's base URL? (e.g., https://myblog.com)
User: https://myblog.com

[You explore their codebase]

You: I found:
- Markdown files in: src/posts/
- Images in: public/images/
- Frontmatter format: YAML with title, date, tags
- URL structure: /posts/{slug}

Creating conversion script...

[Generate and run custom script]

✅ Preview & Medium editor opened!
- Title: My Post
- 3 images to upload (markers added)
- References formatted as paragraphs
- Footer links to: https://myblog.com/posts/2024-01-15-my-post

SUPER SIMPLE Next Steps:
1. Click the BIG GREEN BUTTON (or click anywhere in content box) to copy
2. Switch to Medium tab and paste (Cmd/Ctrl+V)
3. Upload 3 images at the clearly marked spots
4. Publish!
```

## Key Differences from Hardcoded Script

❌ **Old way**: Hardcoded paths, specific to Kanaeru
✅ **New way**: Discovers structure, adapts to any blog

❌ **Old way**: One script for one blog
✅ **New way**: Generate custom script per blog

❌ **Old way**: User needs to modify code
✅ **New way**: User just provides blog post + URL

## Universal Best Practices (Always Apply)

These work for ANY blog, ANY structure:

1. **Images** → Upload markers (Medium limitation)
2. **References** → Paragraphs (Medium bug workaround)
3. **Footnotes** → Inline citations (Medium doesn't support footnotes)
4. **Preview** → Auto-open (UX improvement)
5. **Footer** → Specific URL (proper attribution)
6. **HTML** → Clean, minimal (Medium compatibility)

Be thorough in exploring their blog structure. Generate clean, working code. Test the output before declaring success.
