---
name: git-release-flow
description: Automated Git flow for releases using GitHub MCP tools. Detects version changes, creates release branches, generates changelogs, and publishes releases.
user-invocable: true
---

# Git Release Flow

Automated release workflow that integrates with GitHub for version tracking, changelog generation, and release publishing.

## When to Use This Skill

- When user says "release", "publish", "deploy", "ship it"
- When package.json version changes detected
- After completing a feature milestone
- For semantic versioning workflows

## Prerequisites

- Repository must be git initialized
- GitHub remote must be configured
- User must have push permissions
- Working tree must be clean

## Release Flow

1. **Version Detection**: Check for version changes in package.json, Cargo.toml, pyproject.toml
2. **Changelog Generation**: Compare commits since last tag
3. **Branch Creation**: Create release branch (release/vX.Y.Z) or use main
4. **Tag Creation**: Create annotated git tag with changelog
5. **GitHub Release**: Use GitHub MCP tools for release creation
6. **Push**: Push tags and branches to remote

## Work Procedure

### 1. Detect Version Change
```bash
git diff HEAD~1 -- package.json | grep version
git diff HEAD~1 -- pyproject.toml | grep version
git diff HEAD~1 -- Cargo.toml | grep version
```

### 2. Validate Version
Ensure semantic versioning (MAJOR.MINOR.PATCH)

### 3. Generate Changelog
```bash
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "HEAD~10")
git log $LAST_TAG..HEAD --oneline --no-merges
```

### 4. Create Release Branch (Optional)
```bash
git checkout -b release/v$VERSION
```

### 5. Create Annotated Tag
```bash
git tag -a "v$VERSION" -m "Release $VERSION

## Changes
$CHANGELOG"
```

### 6. Push to GitHub
```bash
git push origin main --tags
```

### 7. Create GitHub Release (via MCP)
Use `github___create_release` or `gh release create`

## Changelog Template

```markdown
# v1.2.3 (2026-03-17)

## Features
- Description of new feature

## Fixes
- Description of bug fix

## Breaking Changes
- Description of breaking change (if any)

## Contributors
- @username
```

## Safety Checks

- [ ] Never force push to main
- [ ] Always confirm with user before publishing
- [ ] Check for uncommitted changes before release
- [ ] Validate CI status before release
- [ ] Ensure tests pass before release

## Hook Integration

Triggered by MCP keyword detector:
- "release"
- "publish version"
- "ship it"
- "deploy version"
- "create release"

## Example Commands

```bash
# Full release flow (interactive)
droid skill git-release-flow

# Dry run (show what would happen)
droid skill git-release-flow --dry-run

# Just generate changelog
droid skill git-release-flow --changelog-only

# With automatic GitHub release
droid skill git-release-flow --github-release
```

## Version Bump Types

- **MAJOR (X.0.0)**: Breaking changes
- **MINOR (0.X.0)**: New features, backwards compatible
- **PATCH (0.0.X)**: Bug fixes, backwards compatible
