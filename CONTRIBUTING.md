# Contributing to Scalpel

Thank you for your interest in making Scalpel sharper. Here's how you can contribute.

## Ways to Contribute

### 1. Add Reconnaissance Dimensions

Scalpel currently scans 12 dimensions. You can add new ones:

1. Fork the repo
2. Edit `src/scalpel.md`
3. Add a new section under Phase 1 (e.g., "1.13 Accessibility Audit")
4. Include the specific bash commands and file patterns to scan
5. Add corresponding scoring criteria
6. Submit a PR with an example of the output

### 2. Add Surgical Team Templates

Different project types need different teams. Add yours:

1. Edit `src/scalpel.md` Phase 3
2. Add a new team pattern with:
   - Detection criteria (what project signals trigger this team)
   - Team roles (3-6 specialists)
   - File jurisdiction examples
3. Submit a PR with a real-world example

### 3. Add Agent Adapters

Scalpel currently has full support for Claude Code. Adapters for other agents:

- **Codex CLI** — how to inject Scalpel's agent prompt
- **Gemini CLI** — system prompt integration
- **Cursor** — `.cursorrules` format adapter
- **Windsurf** — rules file adapter
- **Aider** — conventions file adapter

### 4. Improve Scoring Rules

Add new quality violations to detect in Phase 4:

1. Define the violation (what bad behavior looks like)
2. Define the deduction amount (-5 to -20)
3. Define how to detect it (grep pattern, build output, etc.)
4. Submit a PR

### 5. Report Bugs and Suggest Features

Open an issue with:
- What you expected to happen
- What actually happened
- Your project type (framework, language)
- Your coding agent (Claude Code, Codex, etc.)

## Development Setup

```bash
git clone https://github.com/anupmaster/scalpel.git
cd scalpel

# Test on a sample project
cd /path/to/your/test/project
/path/to/scalpel/install.sh

# Start Claude Code and test
claude
> Hi Scalpel, start work
```

## PR Guidelines

- Keep changes focused (one feature/fix per PR)
- Test on at least one real project before submitting
- Update README if adding user-facing features
- Follow existing code style (the irony of an AI tool having a style guide is not lost on us)

## Code of Conduct

Be excellent to each other. That's the whole policy.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
