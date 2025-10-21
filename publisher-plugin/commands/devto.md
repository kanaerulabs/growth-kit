---
description: Generate Dev.to-optimized RSS feed for automatic article import
tags: [devto, rss, blog, syndication]
---

Generate a Dev.to-optimized RSS feed that can be used to automatically import your blog posts to Dev.to.

**What this does:** Creates an RSS feed with HTML-encoded content that Dev.to can import and convert to their markdown format.

---

## Process

### 1. Understand the Blog Structure

**Scan the codebase to understand:**
- Where are markdown blog posts stored?
- What frontmatter format is used?
- What's the blog base URL?
- Where are images/diagrams located?

**Common blog structures:**
- `src/content/blog/posts/{en,ja}/*.md`
- `content/blog/*.md`
- `posts/*.md`
- `blog/*.md`

### 2. Read All Blog Posts

**Use Glob to find all markdown files:**
- Search pattern: `**/*.md` in blog directories
- Read each file with Read tool
- Extract frontmatter (title, description, date, author)
- Extract markdown content

**For each post:**
```typescript
{
  title: string,
  description: string,
  date: string,
  author: string,
  slug: string,
  content: string (markdown),
  url: string (full blog post URL)
}
```

### 3. Convert Markdown to HTML

**Dev.to Requirements:**
- Content must be HTML (in `<content:encoded>` field)
- All URLs must be absolute (not relative)
- Images must use absolute URLs
- Dev.to will convert the HTML back to markdown on their end

**Conversion process:**
- Convert markdown to HTML (use marked.js if available, or simple conversion)
- Make all image URLs absolute
- Make all links absolute
- Preserve code blocks and formatting

### 4. Generate RSS Feed

**Create XML file with RSS 2.0 format:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>Blog Title</title>
    <description>Blog Description</description>
    <link>https://yourblog.com</link>
    <atom:link href="https://yourblog.com/rss-devto.xml" rel="self" type="application/rss+xml"/>
    <language>en</language>

    <item>
      <title>Post Title</title>
      <link>https://yourblog.com/blog/post-slug</link>
      <guid>https://yourblog.com/blog/post-slug</guid>
      <pubDate>Mon, 01 Jan 2025 00:00:00 GMT</pubDate>
      <description>Post description</description>
      <content:encoded><![CDATA[
        <!-- HTML content here with absolute URLs -->
      ]]></content:encoded>
      <dc:creator>Author Name</dc:creator>
    </item>

    <!-- More items... -->
  </channel>
</rss>
```

### 5. Save and Output

**Save the RSS feed:**
- File location: `public/rss-devto.xml` (or project root)
- Ensure proper XML formatting
- Validate the feed structure

**Auto-open Dev.to settings:**
```bash
# Automatically open Dev.to RSS settings page
open https://dev.to/settings/extensions
```

**Display to user with clear actions:**
```
✅ Dev.to RSS feed generated & settings opened!
════════════════════════════════════════

📄 File Created: public/rss-devto.xml
🔗 Feed URL: https://yourblog.com/rss-devto.xml
🌐 Browser: Dev.to settings page opened

📋 SIMPLE Next Steps:
  1️⃣ Deploy your site (RSS needs to be live)
  2️⃣ Dev.to settings is now open in browser
  3️⃣ Scroll to "Publishing from RSS" section
  4️⃣ Paste: https://yourblog.com/rss-devto.xml
  5️⃣ Click "Submit" - posts will auto-import!

📝 Posts included: X articles
  - Article 1 title
  - Article 2 title
  - Article 3 title

💡 TIP: Dev.to checks RSS every ~30 minutes for new content
```

---

## Dev.to RSS Import Setup

Once the RSS feed is generated and deployed:

1. **Go to Dev.to Settings**
   - Visit: https://dev.to/settings/extensions
   - Scroll to "Publishing from RSS" section

2. **Add Your RSS Feed**
   - Enter: `https://yourblog.com/rss-devto.xml`
   - Click "Submit"

3. **Configure Import Settings**
   - Choose: "Publish immediately" or "Save as draft"
   - Set canonical URL (points back to your blog)

4. **Automatic Syncing**
   - Dev.to checks your RSS feed periodically
   - New posts are automatically imported
   - Updates to existing posts are NOT synced (manual edits on Dev.to remain)

---

## Key Differences from Regular RSS

**Dev.to-Optimized RSS:**
- Uses HTML in `<content:encoded>` (not plain markdown)
- All URLs are absolute (no relative paths)
- Includes `<dc:creator>` for author attribution
- Uses `<guid>` for unique identification

**Regular RSS:**
- May use plain text or summary in description
- Can have relative URLs
- May not include full HTML content

---

## Troubleshooting

**Q: Dev.to isn't importing my posts?**
- Check RSS feed is publicly accessible
- Validate XML syntax
- Ensure all URLs are absolute
- Check pubDate format (RFC 822)

**Q: Images not showing on Dev.to?**
- Ensure image URLs are absolute (https://...)
- Images must be publicly accessible
- Dev.to may cache images

**Q: Want to update an existing post?**
- RSS updates don't sync to Dev.to after initial import
- You must manually edit on Dev.to for updates

---

## Example Output

After running this command, you'll have:

```
public/rss-devto.xml
```

With content like:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/">
  <channel>
    <title>Your Blog</title>
    <link>https://yourblog.com</link>
    <item>
      <title>How to Build AI Agents</title>
      <link>https://yourblog.com/blog/2025-01-15-ai-agents</link>
      <guid>https://yourblog.com/blog/2025-01-15-ai-agents</guid>
      <pubDate>Wed, 15 Jan 2025 00:00:00 GMT</pubDate>
      <description>Learn how to build production-ready AI agents</description>
      <content:encoded><![CDATA[
        <h1>How to Build AI Agents</h1>
        <p>AI agents are transforming...</p>
        <img src="https://yourblog.com/images/diagram.png" alt="Architecture" />
        <!-- Full HTML content -->
      ]]></content:encoded>
    </item>
  </channel>
</rss>
```

---

## Implementation Notes

**DO NOT use npm scripts.** Generate the RSS feed directly using:
- Glob tool to find markdown files
- Read tool to parse frontmatter and content
- Built-in text processing to convert markdown → HTML
- Write tool to save `public/rss-devto.xml`

**Date formatting:** Use RFC 822 format for `<pubDate>`:

**CRITICAL: For bash scripts, use bash date command** (NOT JavaScript):
```bash
# Convert YYYY-MM-DD to RFC 822 in bash
date -u -d "2025-01-15" "+%a, %d %b %Y %H:%M:%S GMT"
# Output: "Mon, 15 Jan 2025 00:00:00 GMT"

# Or for current date:
date -u "+%a, %d %b %Y %H:%M:%S GMT"
```

**If generating with TypeScript/Node** (using npx tsx):
```javascript
new Date(post.date).toUTCString()
// Output: "Mon, 15 Jan 2025 00:00:00 GMT"
```

**DO NOT** use `new Date()` syntax in bash heredocs - it will cause "Bad substitution" errors!

**URL construction:**
- Detect base URL from blog structure or ask user
- Construct: `${baseUrl}/blog/${slug}`
- Ensure all image paths are absolute

**Limit to recent posts:** Generate RSS for last 10-20 posts (Dev.to recommendation)
