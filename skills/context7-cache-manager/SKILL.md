---
name: context7-cache-manager
description: Manage Context7 documentation cache with JSON + TTL for faster responses. Use before calling context7 MCP tools.
user-invocable: true
---

# Context7 Cache Manager

Cache Context7 documentation locally for faster responses and reduced API calls.

## When to Use This Skill

- Before calling `context7___query-docs`
- When you need library documentation repeatedly
- To reduce Context7 API calls and costs
- When working offline or with slow network

## Cache Strategy

- Default TTL: 24 hours (86400 seconds)
- Cache location: `~/.factory/cache/context7/`
- Auto-invalidate expired entries
- JSON format with metadata

## Work Procedure

### 1. Check Cache First
```bash
~/.factory/bin/context7-cache get /facebook/react
```

### 2. If Cache Miss
Call `context7___query-docs` as normal

### 3. Cache Result
```bash
~/.factory/bin/context7-cache set /facebook/react '<json_data>'
```

### 4. Periodic Cleanup
```bash
~/.factory/bin/context7-cache clear --expired
```

## Cache File Format

```json
{
  "library_id": "/facebook/react",
  "data": { ... context7 response ... },
  "cached_at": "2026-03-17T10:00:00Z",
  "ttl_seconds": 86400,
  "size_bytes": 15234
}
```

## CLI Reference

```bash
# Get cached or return miss
context7-cache get <library_id>

# Cache result
context7-cache set <library_id> '<json_data>'

# List cached libraries with TTL status
context7-cache list

# Show cache stats (size, hit rate, entries)
context7-cache stats

# Clear expired entries only
context7-cache clear --expired

# Clear all cache
context7-cache clear --all
```

## Integration Pattern

```python
# Instead of always calling MCP:
cached = context7_cache_get("/facebook/react")
if not cached:
    docs = context7___query_docs("/facebook/react", "hooks")
    context7_cache_set("/facebook/react", docs)
else:
    docs = cached["data"]
```

## Cache Invalidation

- **Time-based**: Entries expire after TTL (default 24h)
- **Manual**: `clear --expired` removes stale entries
- **Version-based**: Can be extended to check library version changes

## Storage

- Location: `~/.factory/cache/context7/`
- Format: One JSON file per library (sanitized filename)
- Metadata: `~/.factory/cache/context7/.metadata.json`

## Example Session

```
> User: How do I use React hooks?

1. Check cache: context7-cache get /facebook/react
2. Cache miss - calling Context7 MCP...
3. Caching result for 24h
4. Using cached docs to answer...
```
