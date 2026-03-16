# Personal Configuration (Auto-Injected into Missions)

> This content is automatically included in all Factory missions.

---

## MCP Auto-Invoke Rules

**When you detect these keywords, automatically invoke the corresponding MCP tool:**

| MCP | Keywords / Triggers | Tools to Use |
|-----|-------------------|--------------|
| **context7** | react, next.js, vue, angular, tailwind, python, node, library, framework, API, docs, hooks, components | `context7___resolve-library-id` + `context7___query-docs` |
| **aws-knowledge** | aws, lambda, ec2, s3, dynamodb, bedrock, serverless, cloud, vpc, architecture | `aws-knowledge___aws___search_documentation` + `aws-knowledge___aws___read_documentation` |
| **aws-pricing** | pricing, cost, cuánto, precio, expensive, cheap, estimate | `aws-knowledge___aws___read_documentation` (pricing pages) |
| **localstack** | localstack, mock aws, test locally, dev aws, local s3, local lambda | `localstack-mcp-server___localstack-aws-client` |
| **github** | github, repo, git, pr, pull request, issue, commit, branch, ci/cd | `github___*` tools |
| **playwright** | playwright, test, e2e, browser test, automation, screenshot | `playwright___browser_*` tools |
| **memory** | remember, recall, save memory, store context, previous session | `memory___*` tools |

### Priority Order (if multiple MCPs match)

1. Explicit MCP request from user
2. Most specific keyword match
3. Cloud/Architecture first for infrastructure questions
4. Context7 for code/library questions

---

## Droid Voice (TTS)

**Droid has voice synthesis enabled.** Speak automatically when completing tasks.

### Auto-Invoke

Execute after completing meaningful work:
```bash
~/.factory/hooks/droid-speak.sh "Listo. Completé [descripción]." &
```

### Scenario-Based Voices

| Scenario | Voice | Trigger Keywords |
|----------|-------|------------------|
| Software Dev | es-MX-JorgeNeural | create, edit, implement, build |
| Cloud/AWS | es-ES-AlvaroNeural | aws, lambda, deploy, infrastructure |
| Debug | es-AR-TomasNeural | fix, bug, error, debug |
| Research | es-ES-XimenaNeural | search, find, investigate, analyze |

---

## Available Custom Droids

**Use these via Task tool with `subagent_type`:**

| Droid | Description | Usage |
|-------|-------------|-------|
| `worker` | General-purpose worker for parallel tasks | Research, analysis, code exploration |
| `docs-fetcher` | Fetch documentation via Context7 | Library/API docs |
| `bmad-dev` | Development specialist | Feature implementation |
| `bmad-architect` | Architecture design | System design, patterns |
| `bmad-qa` | QA/Testing specialist | Test planning, validation |
| `bmad-security` | Security analysis | Security audits, reviews |
| `diagram-architect` | Architecture diagrams | Visual documentation |

---

## Available Skills

| Skill | When to Use |
|-------|-------------|
| `context7-docs` | Fetching library documentation |
| `xlsx-official` | Excel/spreadsheet work |
| `vercel-react-best-practices` | React best practices (Vercel) |
| `vercel-composition-patterns` | Composition patterns for UI | 
| `vercel-react-native-skills` | React Native guidance |
| `web-design-guidelines` | UI/UX review |
| `vercel-deploy` | Vercel deployment workflows |
| `next-best-practices` | Next.js best practices |
| `next-cache-components` | Next.js caching and component patterns |
| `next-upgrade` | Next.js upgrade guidance |
| `cra-to-next-migration` | CRA to Next.js migrations |
| `turborepo` | Monorepo workflows |
| `ai-sdk` | Vercel AI SDK usage |
| `ai-elements` | AI UI elements |
| `streamdown` | Streaming markdown/MDX |
| `building-components` | Component design guidance |
| `agent-browser` | Browser automation |
| `vercel-cli` | Vercel CLI usage |
| `autoship` | Release automation |
| `ucp` | Agentic commerce workflows |
| `workflow` | Workflow orchestration |
| `json-render-core` | JSON Render core patterns |
| `json-render-react` | JSON Render for React |
| `json-render-react-native` | JSON Render for React Native |
| `json-render-remotion` | JSON Render for Remotion |
| `remotion-best-practices` | Remotion best practices |
| `find-skills` | Discover skills from Skills.sh |
| `before-and-after` | Before/after comparisons |

---

## Code Style

- Write clean, readable, maintainable code
- Use meaningful variable and function names
- Keep functions focused and small
- TypeScript: Prefer `interface` over `type`, avoid `any`
- React: Functional components with hooks

## Tool Preferences

- Use `Read` tool over shell `cat`
- Use `LS` tool over `ls` command
- Use `Grep`/`Glob` tools over `find`/`grep` CLI
- Use Context7 MCP for documentation before general knowledge
