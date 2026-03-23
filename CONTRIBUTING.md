# Contributing to Scalpel

Thank you for your interest in making Scalpel sharper. Here's how you can contribute.

## Ways to Contribute

### 1. Add Scan Dimensions

Scalpel scans 12 dimensions. Add new ones:

1. Edit `src/scanner.sh` — add a new `scan_*()` function
2. Edit `src/scalpel.md` Phase 1 — add the dimension for AI-powered analysis
3. Add scoring criteria in `calculate_score()`
4. Update all adapters in `src/adapters/` with matching content
5. Submit a PR with example output

**Ideas:** accessibility (WCAG), i18n readiness, GraphQL schema health, mobile responsiveness, API versioning.

### 2. Add Surgical Team Templates

Different project types need different teams:

1. Edit `src/scalpel.md` Phase 3
2. Add a new team pattern with detection criteria, team roles (3-6), and file jurisdiction examples
3. Submit a PR with a real-world example

### 3. Create Stack-Specific Configs

Share your `scalpel.config.json` for specific stacks:

- `scalpel-nextjs` — Next.js optimized scanning + teams
- `scalpel-django` — Python/Django patterns
- `scalpel-rails` — Ruby on Rails conventions
- `scalpel-rust` — Cargo-aware scanning
- `scalpel-flutter` — Dart/Flutter mobile patterns

Submit them to [awesome-scalpel](https://github.com/anupmaster/awesome-scalpel).

### 4. Improve Agent Adapters

Each adapter in `src/adapters/` translates the Scalpel protocol for a specific tool. Improve accuracy, add tool-specific features, or fix formatting issues.

### 5. Improve the Scanner

`src/scanner.sh` is the core detection engine. Contributions:

- Better framework detection (new package patterns)
- More accurate scoring rules
- Cross-platform compatibility fixes (macOS, Linux, WSL)
- Performance optimizations

### 6. Report Bugs and Suggest Features

Open an issue with:
- What you expected vs what happened
- Your project type (framework, language)
- Your coding agent (Claude Code, Codex, Gemini, etc.)
- Scanner output (if relevant)

## Development Setup

```bash
git clone https://github.com/anupmaster/scalpel.git
cd scalpel

# Run the scanner test suite
bash tests/scanner/setup_fixtures.sh
bash tests/scanner/run_tests.sh

# Test on a real project
cd /path/to/your/project
/path/to/scalpel/install.sh

# Start your agent and test
claude
> Hi Scalpel, start work
```

## PR Guidelines

- One feature or fix per PR
- Test on at least one real project before submitting
- Run `bash tests/scanner/run_tests.sh` and ensure all 36 tests pass
- Update README if adding user-facing features
- Update CHANGELOG.md
- Update all 6 adapters if changing the Scalpel protocol

## Code of Conduct

Be excellent to each other. That's the whole policy.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

<p align="center">
  <sub>Maintained by <a href="https://github.com/anupmaster"><strong>Anup Karanjkar</strong></a></sub>
</p>
