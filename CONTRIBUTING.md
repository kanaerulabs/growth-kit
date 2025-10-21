# Contributing to Growth Kit

Thanks for your interest in contributing to Growth Kit! 🎉

This guide will help you get started.

---

## How to Contribute

### 1. Add New Platform Commands

The easiest way to contribute is adding support for new platforms.

**Steps:**
1. Create a new command file: `publisher-plugin/commands/[platform].md`
2. Follow the existing command structure (see `x.md` as reference)
3. Add universal input detection (markdown, PDF, URL, slug)
4. Update README.md with examples
5. Test thoroughly with actual blog content
6. Submit a PR

**Good platforms to add:**
- Reddit post generator
- Bluesky thread generator
- Hacker News comment formatter
- Email newsletter version
- Substack formatter

### 2. Improve Existing Commands

**Ideas:**
- Better prompt templates
- More platform-specific optimizations
- Improved error handling
- Better input detection
- Support for more file formats

### 3. Test with Different Blog Structures

Help us support more blog setups:
- Test with Gatsby, Next.js, Astro, Hugo, etc.
- Report issues with specific blog structures
- Suggest improvements for auto-detection

### 4. Documentation

- Add more examples
- Improve installation instructions
- Add screenshots
- Write tutorials
- Fix typos

---

## Development Setup

```bash
# Clone the repo
git clone https://github.com/kanaerulabs/growth-kit.git
cd growth-kit

# That's it! No dependencies to install.

# Test commands locally
# Install as plugin in Claude Code:
/plugin marketplace add /path/to/growth-kit
/plugin install publisher
/plugin install analytics

# Then test with actual blog content
/publisher:x my-blog-post
```

---

## Command File Structure

All commands are markdown files with frontmatter:

```markdown
---
description: Brief description of what this command does
argument-hint: <input> [lang]
tags: [relevant, tags, here]
---

Command instructions here...

## Process

1. Step one
2. Step two
...
```

**Key principles:**
- Universal input detection (markdown, PDF, URL, slug)
- Clear step-by-step process
- Error handling instructions
- Examples of expected output

---

## Pull Request Process

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/add-reddit-command`
3. **Make your changes**
4. **Test thoroughly**: Install as plugin and test all scenarios
5. **Update documentation**: README.md, command descriptions, examples
6. **Commit with clear message**: Describe what and why
7. **Push and create PR**: Use our PR template
8. **Wait for review**: We'll review and provide feedback

---

## PR Template

When creating a PR, please include:

- **What**: What does this PR add/fix/improve?
- **Why**: Why is this change needed?
- **Testing**: How did you test this?
- **Screenshots**: Show the output (if applicable)
- **Breaking Changes**: Any breaking changes?

---

## Code Style

- Use clear, descriptive variable names
- Keep commands focused on one task
- Follow existing patterns in other commands
- Comment complex logic
- Keep it simple - prioritize clarity over cleverness

---

## Testing Checklist

Before submitting a PR, verify:

- [ ] Command works with markdown files
- [ ] Command works with slugs
- [ ] Command works with URLs
- [ ] Error messages are helpful
- [ ] Output format is correct
- [ ] Documentation is updated
- [ ] No breaking changes to existing commands
- [ ] Tested on actual blog content
- [ ] Tested in non-JavaScript repo (Python, Rust, etc.)
- [ ] Uses only Claude's built-in tools (Read, Write, Bash)

---

## Need Help?

- **Questions**: Open a [GitHub Discussion](https://github.com/kanaerulabs/growth-kit/discussions)
- **Bugs**: Open an [Issue](https://github.com/kanaerulabs/growth-kit/issues)
- **Ideas**: Open an [Issue](https://github.com/kanaerulabs/growth-kit/issues) with "enhancement" label
- **Email**: support@kanaeru.ai

---

## Code of Conduct

Be respectful, helpful, and constructive. We're all here to learn and build something useful together.

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing!** 🙏

Every contribution, no matter how small, helps make Growth Kit better for everyone.
