---
name: context7-docs
description: Fetch current documentation and check architecture compatibility using Context7 MCP. Use when working with libraries, frameworks, or checking version compatibility.
user-invocable: true
disable-model-invocation: false
---

# Context7 Documentation Fetcher

Fetch up-to-date documentation for any library using Context7 MCP tools. This ensures you work with the latest API signatures and compatibility information.

## When to Use

- Implementing features with libraries or frameworks
- Checking version compatibility between packages
- Looking up API parameters and signatures
- Finding migration guides for upgrades

## Tools Available

| Tool | Purpose |
|------|---------|
| `context7___resolve-library-id` | Convert library name to Context7 ID |
| `context7___query-docs` | Fetch documentation for a library |

## Workflow

### Step 1: Resolve Library ID

```
context7___resolve-library-id(
  libraryName: "react",
  query: "useState useEffect hooks API"
)
```

Returns library IDs like `/facebook/react` or `/vercel/next.js`

### Step 2: Query Documentation

```
context7___query-docs(
  libraryId: "/facebook/react",
  query: "useState hook usage and rules"
)
```

Returns relevant documentation snippets and code examples.

## Compatibility Checking

For multi-library checks:

1. Resolve all involved libraries
2. Query each for compatibility info
3. Cross-reference version requirements
4. Report peer dependencies and breaking changes

## Fallback

If Context7 doesn't have the library:
- Use `WebSearch` to find official docs
- Use `FetchUrl` to read documentation pages
- Always prefer official sources

---

**Remember**: Context7 provides current documentation. Training data can be outdated. Always verify with Context7.
