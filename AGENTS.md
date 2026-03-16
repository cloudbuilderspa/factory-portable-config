# Global Agent Instructions

> Personal preferences and instructions for all droid sessions across all projects.

## 🚀 SPEAK NOW! - Voice Auto-Invoke

**IMPORTANT: Every time you finish something, YOU MUST run this command:**

```bash
/Users/asuresky/.factory/hooks/droid-speak.sh "Mensaje en español" &
```

**Just do it after any completion. Don't ask. Just speak.**

### Scenario-Based Voices (auto-detect):
- **Software Dev**: "Listo. Completé el desarrollo de [tarea]."
- **Cloud/AWS**: "Listo. Desplegué la infraestructura en AWS."
- **IA Architecture**: "Listo. Completé el diseño de la arquitectura de IA."
- **Claude Code**: "Listo. Configuré Claude Code."
- **Droid**: "Listo. Completé la configuración de Droid."
- **Kubernetes**: "Listo. Desplegué en Kubernetes."
- **Debug**: "Listo. Corregí el error."
- **Research**: "Listo. Encontré la información."

## Context7 Auto-Invoke Rule

**Always use Context7 MCP when I need library/API documentation, code generation, setup or configuration steps without me having to explicitly ask.**

---

## Documentation & Architecture Compatibility

### ALWAYS Use Context7 for Documentation

When working with any library, framework, or technology, **ALWAYS fetch up-to-date documentation** using Context7 MCP tools before relying on training knowledge:

1. **First**: Call `context7___resolve-library-id` with:
   - `libraryName`: The library/package name (e.g., "react", "next.js", "tailwindcss")
   - `query`: The specific question or task context

2. **Second**: Call `context7___query-docs` with:
   - `libraryId`: The ID returned from resolve (format: `/org/project` or `/org/project/version`)
   - `query`: Specific documentation question

### Context7 Tools (Factory Droid)

- **Resolve**: `context7___resolve-library-id` - Find library ID from name
- **Query**: `context7___query-docs` - Fetch documentation
- **Custom Droid**: Use Task tool with `subagent_type: docs-fetcher` for dedicated research

### When to Use Context7

- **Before implementing** any feature using a library
- **Checking version compatibility** between dependencies
- **Looking up API signatures** and parameters
- **Finding breaking changes** between versions
- **Migration guides** when upgrading packages
- **Best practices** and recommended patterns

### Architecture Compatibility Protocol

When suggesting or implementing changes involving libraries:

1. Resolve library IDs for all involved packages
2. Query documentation for:
   - Version requirements and peer dependencies
   - Breaking changes between current and target versions
   - Integration patterns with other libraries
3. Verify compatibility before proceeding
4. Document any version constraints discovered

### Example Usage Pattern

```
# Before using React hooks:
1. context7___resolve-library-id("react", "useState useEffect hooks API")
2. context7___query-docs("/facebook/react", "useState useEffect hooks API parameters")

# Before integrating Next.js with Tailwind:
1. context7___resolve-library-id("next.js", "tailwindcss integration")
2. context7___resolve-library-id("tailwindcss", "next.js setup")
3. Query both for integration requirements
```

### Fallback

If Context7 doesn't have the library:
- Use `WebSearch` to find official documentation
- Use `FetchUrl` to read documentation pages directly
- Always prefer official sources over training knowledge

---

## AWS Pricing Auto-Invoke Rule

**Always use AWS Pricing MCP tools when user asks about AWS service costs, pricing, or estimates.**

### When to Use AWS Pricing Tools

- When user asks "how much does [AWS service] cost?"
- When user asks about AWS pricing for Lambda, EC2, S3, RDS, etc.
- When user wants cost estimates or pricing calculations
- When user asks about AWS service pricing in Spanish ("cuánto cuesta", "precio de", etc.)

### AWS Pricing Tools Available

1. **`aws-knowledge___aws___search_documentation`** - Search AWS pricing docs
2. **`aws-knowledge___aws___read_documentation`** - Read official AWS pricing pages
3. **`aws-pricing___get_pricing_service_codes`** - Get available service codes
4. **`aws-pricing___get_pricing_service_attributes`** - Get filterable attributes
5. **`aws-pricing___get_pricing_attribute_values`** - Get valid values for filters
6. **`aws-pricing___get_pricing`** - Get actual pricing data

### Workflow for AWS Pricing Queries

1. **First**: Use `aws-knowledge___aws___search_documentation` to find pricing info
2. **Then**: Use `aws-knowledge___aws___read_documentation` to read official pricing page (e.g., https://aws.amazon.com/{service}/pricing/)
3. **If needed**: Use `aws-pricing___get_pricing_*` tools for specific pricing data

### Example Patterns

```
# User asks: "¿Cuánto cuesta Lambda?" or "Lambda pricing"
1. aws-knowledge___aws___search_documentation with search_phrase="AWS Lambda pricing"
2. aws-knowledge___aws___read_documentation with url="https://aws.amazon.com/lambda/pricing/"

# User asks: "EC2 pricing"
1. aws-knowledge___aws___read_documentation with url="https://aws.amazon.com/ec2/pricing/"
```

### Important Notes

- Use `aws-knowledge` tools first for documentation lookup
- Fall back to `aws-pricing` tools only if knowledge tools don't provide enough detail
- Prioritize official AWS documentation over web search
- Always fetch current pricing from AWS docs, don't rely on training knowledge

---

## Cloud Architecture Auto-Invoke Rule

**When working on cloud architectures, compare options and fetch official documentation for scalable, resilient, and cost-effective solutions.**

### MCPs Available for Cloud Architecture

| MCP | Purpose | Tools |
|-----|---------|-------|
| **aws-knowledge** | AWS services, architecture patterns | search_documentation, read_documentation, recommend |
| **aws-documentation** | AWS official docs | search_documentation, read_documentation |
| **aws-pricing** | AWS pricing data | get_pricing, get_pricing_service_codes, get_pricing_attribute_values |
| **localstack** | Local AWS development | aws-client, deployer, cloud-pods |
| **vercel** | Vercel deployment & serverless | (via Vercel MCP tools) |
| **supabase** | Supabase backend & database | (via Supabase MCP tools) |
| **context7** | Library/framework docs | resolve-library-id, query-docs |

### When to Use Each MCP

#### AWS Services & Architecture
- **When user asks about AWS architecture** → Use `aws-knowledge___aws___search_documentation` and `aws-knowledge___aws___read_documentation`
- **When comparing AWS services** (e.g., Lambda vs Fargate, DynamoDB vs RDS) → Search and compare official docs
- **When asking about AWS costs** → Use AWS pricing tools (see section above)
- **When user mentions "serverless", "AWS", "Lambda", "EC2", "S3", "DynamoDB"** → Invoke AWS MCP

#### LocalStack (Local AWS Development)
- **When user wants to test AWS architecture locally** → Use LocalStack MCP
- **When testing Lambda, S3, DynamoDB, SNS, SQS, etc. locally** → Use `localstack-mcp-server___localstack-aws-client`
- **When deploying infrastructure locally** → Use `localstack-mcp-server___localstack-deployer`
- **Keywords**: "localstack", "test locally", "dev environment", "mock AWS"

#### Vercel (Frontend/Serverless)
- **When user asks about Vercel deployment, Next.js, or serverless frontend** → Use Vercel MCP
- **When comparing Vercel vs AWS Amplify vs other frontend platforms**
- **Keywords**: "vercel", "next.js deployment", "serverless frontend", "Vercel functions"

#### Supabase (Backend/DB Serverless)
- **When user asks about Supabase, PostgreSQL, auth, or realtime** → Use Supabase MCP
- **When comparing Supabase vs Firebase vs DynamoDB**
- **Keywords**: "supabase", "postgresql", "backend serverless", "auth", "realtime database"

#### Context7 (Libraries & Frameworks)
- **When user asks about library/framework usage** → Use Context7 (see section above)
- **When comparing React vs Vue, Next.js vs Nuxt, etc.**

### Architecture Comparison Workflow

When user asks to compare architectures or services:

1. **Identify the use case** - What problem are we solving?
2. **Fetch official docs** for each option using appropriate MCP
3. **Compare** - Scalability, cost, complexity, vendor lock-in
4. **Recommend** - Best option with reasoning

### Example Comparison Queries

```
# Compare Lambda vs Fargate
1. aws-knowledge___aws___search_documentation("AWS Lambda vs Fargate comparison")
2. aws-knowledge___aws___read_documentation(url from search)

# Compare Supabase vs DynamoDB
1. context7___resolve-library-id("supabase", "database features comparison")
2. aws-knowledge___aws___search_documentation("DynamoDB vs Supabase")

# Local development with LocalStack
1. localstack-mcp-server___localstack-management(action="status")
2. localstack-mcp-server___localstack-aws-client(command="s3 ls")
```

### Key Architecture Principles

- **Scalability**: Prefer serverless (Lambda, Fargate, Vercel, Supabase) for variable workloads
- **Resilience**: Use multi-AZ, managed services, proper caching
- **Cost-effective**: Use pricing calculators, prefer pay-per-use over always-on
- **Vendor consideration**: Avoid lock-in where possible, use open standards
- **Local first**: Use LocalStack for development before deploying to AWS

---

## MCP Auto-Invoke Master Table

**When user mentions any of these keywords, automatically invoke the corresponding MCP tool:**

| MCP | Keywords / Triggers | Tools to Use |
|-----|-------------------|--------------|
| **context7** | react, next.js, vue, angular, tailwind, python, node, library, framework, API, docs, hooks, components | `context7___resolve-library-id` + `context7___query-docs` |
| **aws-knowledge** | aws, lambda, ec2, s3, dynamodb, bedrock, serverless, cloud, vpc, architecture, multimodal | `aws-knowledge___aws___search_documentation` + `aws-knowledge___aws___read_documentation` |
| **aws-pricing** | pricing, cost, cuánto, precio, expensive, cheap, estimate | `aws-knowledge___aws___read_documentation` (pricing pages) |
| **aws-documentation** | aws docs, aws guide, aws tutorial (fallback for aws-knowledge) | `aws-documentation___search_documentation` + `aws-documentation___read_documentation` |
| **localstack** | localstack, mock aws, test locally, dev aws, local s3, local lambda | `localstack-mcp-server___localstack-aws-client`, `localstack-mcp-server___localstack-management` |
| **supabase** | supabase, postgresql, postgres, auth, realtime, database, firebase alternative | Supabase MCP tools |
| **vercel** | vercel, next.js deploy, serverless frontend, amplify, vercel deployment | Vercel MCP tools |
| **firebase** | firebase, firestore, google auth, fcm, firebase storage | Firebase MCP tools |
| **playwright** | playwright, test, e2e, browser test, automation, scraping, screenshot | `playwright___browser_*` tools |
| **chrome-devtools** | chrome devtools, debug, inspect, network, devtools | `chrome-devtools___*` tools |
| **github** | github, repo, git, pr, pull request, issue, commit, branch, ci/cd | `github___*` tools (create_issue, create_pr, search_repos, etc.) |
| **memory** | remember, recall, save memory, store context, previous session | `memory___*` tools (store, retrieve, list memories) |
| **sequential-thinking** | think step by step, analyze deeply, complex problem, reasoning | `sequential-thinking___*` tools |
| **aws-cdk-mcp** | cdk, infrastructure as code, cloudformation, iac | `aws-cdk-mcp___*` tools |
| **drawio-mcp** | drawio, diagram, architecture diagram, flowchart | `drawio-mcp___*` tools |
| **excalidraw-mcp** | excalidraw, sketch, whiteboard, hand-drawn diagram | `excalidraw-mcp___*` tools |

### MCP Auto-Invoke Workflow

1. **Detect keywords** in user message
2. **Select appropriate MCP** from table above
3. **Call primary tool** for that MCP
4. **Use fallback tools** if primary doesn't return enough info

### Example Patterns

```
# User: "How to use React useState?"
→ context7___resolve-library-id("react", "useState hooks API")
→ context7___query-docs

# User: "¿Cuánto cuesta Lambda?"
→ aws-knowledge___aws___search_documentation("AWS Lambda pricing")
→ aws-knowledge___aws___read_documentation(url="https://aws.amazon.com/lambda/pricing/")

# User: "Test my Lambda locally"
→ localstack-mcp-server___localstack-management(action="status")
→ localstack-mcp-server___localstack-aws-client(command="lambda list-functions")

# User: "Run e2e tests"
→ playwright___browser_navigate(url="...")
→ playwright___browser_snapshot()

# User: "Compare Supabase vs DynamoDB"
→ context7___resolve-library-id("supabase", "database features")
→ aws-knowledge___aws___search_documentation("DynamoDB vs Supabase")

# User: "Create a PR for this change" or "github repo"
→ github___create_pull_request(title, body, head, base)
→ github___search_repos(query)

# User: "Remember this for later" or "What did we work on yesterday?"
→ memory___store_entities(entities)
→ memory___search_nodes(query)

# User: "Think step by step about this architecture"
→ sequential-thinking___sequentialthinking(thought, thoughtNumber, totalThoughts)

# User: "Setup Firebase auth" or "Firebase vs Supabase"
→ firebase___* tools

# User: "Create a diagram" or "draw architecture"
→ drawio-mcp___* tools
→ excalidraw-mcp___* tools

# User: "CDK infrastructure" or "CloudFormation template"
→ aws-cdk-mcp___* tools
```

### Priority Order (if multiple MCPs match)

1. **Explicit MCP request** from user (e.g., "use localstack to...")
2. **Most specific keyword match** (e.g., "playwright" > "test")
3. **Cloud/Architecture first** for infrastructure questions
4. **Context7** for code/library questions

---

## Vercel Skills.sh & Skills for Agents

**Skills.sh** es el directorio público de "agent skills" - paquetes reutilizables que extienden las capacidades de agentes AI.

### Skills Recomendados

**Skills oficiales de Vercel (Skills.sh):**

- **vercel-labs/agent-skills**: vercel-react-best-practices, vercel-composition-patterns, vercel-react-native-skills, web-design-guidelines, vercel-deploy
- **vercel-labs/next-skills**: next-best-practices, next-cache-components, next-upgrade
- **vercel-labs/migration-skills**: cra-to-next-migration
- **vercel/turborepo**: turborepo
- **vercel/ai**: ai-sdk
- **vercel/ai-elements**: ai-elements
- **vercel/streamdown**: streamdown
- **vercel/components.build**: building-components
- **vercel-labs/agent-browser**: agent-browser
- **vercel/vercel**: vercel-cli
- **vercel-labs/autoship**: autoship
- **vercel-labs/agentic-commerce-skills**: ucp
- **vercel/workflow**: workflow
- **vercel-labs/json-render**: json-render-core, json-render-react, json-render-react-native, json-render-remotion, remotion-best-practices
- **vercel-labs/skills**: find-skills
- **vercel-labs/before-and-after**: before-and-after

### Cuándo Usar Skills

- **React/Next.js** → Usa `vercel-react-best-practices`, `next-best-practices` o `next-cache-components`
- **Migraciones** → Usa `cra-to-next-migration`
- **Deploy y tooling** → Usa `vercel-deploy`, `vercel-cli`, `turborepo`
- **UI/UX** → Usa `web-design-guidelines` o `building-components`
- **IA** → Usa `ai-sdk`, `ai-elements` o `streamdown`
- **Descubrir skills** → Usa `find-skills`

---

## MCPs Populares (npm packages)

**600+ MCP servers disponibles.** Aquí los más útiles para desarrollo:

### Desarrollo & Código

| MCP | npm package | Keywords |
|-----|-------------|----------|
| **filesystem** | @modelcontextprotocol/server-filesystem | "file", "read", "write", "directory" |
| **github** | @modelcontextprotocol/server-github | "github", "repo", "git", "pr", "issue" |
| **sqlite** | @modelcontextprotocol/server-sqlite | "sqlite", "local database" |

### Data & Databases

| MCP | npm package | Keywords |
|-----|-------------|----------|
| **postgres** | @modelcontextprotocol/server-postgres | "postgres", "sql", "database query" |
| **supabase** | @supabase/mcp | "supabase", "postgres" |

### Búsqueda & Web

| MCP | npm package | Keywords |
|-----|-------------|----------|
| **brave-search** | @modelcontextprotocol/server-brave-search | "search web", "internet" |
| **puppeteer** | @modelcontextprotocol/server-puppeteer | "puppeteer", "scrape", "browser" |

### Monitoreo & Notifications

| MCP | npm package | Keywords |
|-----|-------------|----------|
| **sentry** | @modelcontextprotocol/server-sentry | "sentry", "errors", "monitoring" |
| **slack** | @modelcontextprotocol/server-slack | "slack", "notify", "message" |

### Productivity

| MCP | npm package | Keywords |
|-----|-------------|----------|
| **notion** | @modelcontextprotocol/server-notion | "notion", "workspace" |
| **google-maps** | @modelcontextprotocol/server-google-maps | "maps", "geolocation" |

### Installation Example

```bash
# Install MCP server
npx @modelcontextprotocol/server-github

# Or with uv
uvx @modelcontextprotocol/server-filesystem
```

---

## Code Style

### General
- Write clean, readable, maintainable code
- Use meaningful variable and function names
- Keep functions focused and small
- Add comments only when necessary to explain "why", not "what"

### TypeScript
- Prefer `interface` over `type` for object shapes
- Use strict mode
- Avoid `any` - use `unknown` when type is truly unknown

### React
- Prefer functional components with hooks
- Use descriptive component names
- Keep components focused on single responsibility

## Tool Preferences

- Use `Read` tool over shell commands like `cat`
- Use `LS` tool over `ls` command
- Use `Grep` and `Glob` tools over `find` or `grep` CLI
- Use Context7 MCP for documentation before general knowledge

## Communication Style

- Be concise but thorough
- Explain reasoning when asked
- Provide context for decisions made
- Use code examples to illustrate solutions

---

## Droid Voice (TTS)

**Droid has voice synthesis enabled.** Droid MUST speak automatically when completing tasks - this is NOT optional.

### Auto-Invoke Rules

**ALWAYS speak when:**
- You finish a task or complete an action
- You successfully create, edit, or delete files
- You complete a search or analysis
- You finish debugging or fixing an error
- The user asks you to do something and you complete it

**DO NOT ask permission to speak - just speak automatically.**

### How to Speak

Execute this command - it runs in background so it won't slow you down:
```bash
/Users/asuresky/.factory/hooks/droid-speak.sh "your message here" &
```

### What to Say

- **Task completion**: "Listo. Completé la tarea de [descripción]."
- **Errors**: "Hubo un error: [qué falló]. Necesitas que lo intente de nuevo?"
- **Findings**: "Encontré [resultado relevante]."

### Example Auto-Invocations

```
# After creating a file:
/Users/asuresky/.factory/hooks/droid-speak.sh "Creé el archivo config.json con la configuración solicitada." &

# After fixing a bug:
/Users/asuresky/.factory/hooks/droid-speak.sh "Listo. Corregí el error en la función de login." &

# After finding information:
/Users/asuresky/.factory/hooks/droid-speak.sh "Encontré la documentación de la API. Está disponible en el archivo README." &
```

### Important

- The `&` at the end makes it run in background without blocking your work
- ALWAYS speak in Spanish with a friendly tone
- Keep messages short (under 15 words)
- Do NOT speak for every single tool use - only for meaningful completions
