# Growth Kit Architecture

## Design Philosophy

**Zero Dependencies, Maximum Portability**

Growth Kit works in ANY repository type (Python, Rust, Go, JavaScript, Java, etc.) because it relies ONLY on:

1. **Claude Code's built-in tools**
2. **Standard Unix utilities** (bash, curl, sed, grep)

No npm, no Node.js, no jq, no language-specific runtimes.

---

## How It Works

### Command Execution Flow

```
User runs: /publisher:x my-blog-post
    ↓
Claude Code loads: publisher-plugin/commands/x.md
    ↓
Claude follows instructions in markdown using built-in tools:
    ↓
1. Read tool → Find and read blog post
2. Claude's LLM → Generate engaging thread
3. Write tool → Create x-thread-en.html preview
4. Bash tool → open x-thread-en.html && open https://x.com/compose/post
```

### Tools Used

**Read Tool**: Find and parse content

- Searches codebase: `**/*my-post*.md`
- Reads files: markdown, PDF, HTML, plain text
- Parses frontmatter

**Write Tool**: Generate outputs

- HTML previews with copy buttons
- RSS feeds (XML)
- Formatted content files

**Bash Tool**: System interactions

- Open browsers: `open https://x.com/compose/post`
- API calls: `curl -X POST https://api.linkedin.com/rest/posts`
- Text processing: `sed`, `grep` for escaping/parsing

**Claude's LLM**: Content generation

- Reads blog content
- Extracts key insights
- Generates platform-specific copy (thread, post, article)
- Validates character counts
- Creates engaging hooks and CTAs

## LinkedIn API Integration

Uses pure bash + curl for API calls:

```bash
# 1. OAuth (one-time setup)
curl "https://www.linkedin.com/oauth/v2/authorization?..."
# User authorizes → gets code
curl -X POST https://www.linkedin.com/oauth/v2/accessToken ...
# Saves token to .env

# 2. Create post
curl -X POST https://api.linkedin.com/rest/posts \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"author":"urn:li:person:...","commentary":"...","lifecycleState":"DRAFT"}'
```

---

## File Structure

```
growth-kit/
├── publisher-plugin/
│   └── commands/          # Markdown instructions for Claude
│       ├── x.md           # X/Twitter thread generation
│       ├── linkedin.md    # LinkedIn post + API posting
│       ├── medium.md      # Medium article conversion
│       ├── devto.md       # Dev.to RSS feed generation
│       └── all.md         # Run all platforms
│
├── analytics-plugin/
│   └── commands/
│       └── vercel.md      # Vercel Analytics setup
│
│
├── docs/
│   └── screenshots/       # README screenshots
│
├── .env.example           # LinkedIn API config template
└── README.md              # User documentation
```

---
