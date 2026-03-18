#!/usr/bin/env python3
"""
MCP Keyword Detector Hook for Factory Droid
Detects keywords in user prompts and injects MCP tool usage instructions.
Separates AWS Services/Architecture from AWS Pricing.
"""
import json
import os
import re
import sys

# AWS Pricing Keywords (PRIORITY - triggers aws-pricing MCP)
AWS_PRICING_KEYWORDS = [
    r"\bpricing\b", r"\bcost\b", r"\bcosto\b", r"\bprecio\b", r"\bprecios\b",
    r"\bexpensive\b", r"\bcheap\b", r"\bestimate\b", r"\bestimates\b",
    r"\bcu[aá]nto\s*cuesta\b", r"\bcuanto\s*cuesta\b", r"\bhow\s*much\b",
    r"\bprecio\s*de\b", r"\bcosto\s*de\b", r"\bcosts\b",
    r"\bbarato\b", r"\bcaro\b", r"\becon[óo]mico\b",
    r"\bprice\b", r"\bprices\b", r"\btarifa\b", r"\btarifas\b",
    r"\bcostar[áaé]\b", r"\bcostar[áaé]?\b", r"\bcostes\b", r"\bgasto\b", r"\bgastos\b",
    r"\bpresupuesto\b", r"\bpresupuest[oa]\b",
]

# AWS Services/Architecture Keywords (triggers aws-knowledge when no pricing)
AWS_SERVICE_KEYWORDS = [
    r"\baws\b", r"\bamazon\s*web\s*services\b", r"\bamazon\b",
    r"\blambda\b", r"\bec2\b", r"\bs3\b", r"\bdynamodb\b", r"\bdynamo\b",
    r"\bbedrock\b", r"\bserverless\b", r"\bvpc\b", r"\biam\b", r"\bcognito\b",
    r"\bapi\s*gateway\b", r"\bapigateway\b",
    r"\bsqs\b", r"\bsns\b", r"\bkinesis\b", r"\bcloudfront\b",
    r"\brds\b", r"\baurora\b", r"\bdocdb\b", r"\belasticache\b",
    r"\becs\b", r"\beks\b", r"\bfargate\b", r"\bcontainer\b",
    r"\bstep\s*functions\b", r"\beventbridge\b", r"\bsam\b",
    r"\bcdk\b", r"\bcloudformation\b", r"\bterraform\b",
    r"\bcloudwatch\b", r"\bxray\b", r"\bcloudtrail\b",
    r"\bs3\b", r"\befs\b", r"\bfsx\b", r"\bstorage\b",
    r"\balb\b", r"\bclb\b", r"\bnlb\b", r"\belb\b", r"\bload\s*balancer\b",
    r"\broute53\b", r"\bdns\b", r"\bacm\b", r"\bcertificate\s*manager\b",
    r"\bsecrets\s*manager\b", r"\bparameter\s*store\b",
    r"\bsystems\s*manager\b", r"\bssm\b",
    r"\bkms\b", r"\bencryption\b", r"\bsecurity\b",
    r"\blambda@edge\b", r"\bcloudflare\b",
    r"\barchitecture\b", r"\barquitectura\b",
    r"\bservicio\s*aws\b", r"\baws\s*service\b",
    r"\bserverless\s*architecture\b", r"\bmicroservice\b",
]

# Keyword to MCP tool mappings
MCP_KEYWORDS = {
    # Context7 - Library/Framework documentation
    "context7": {
        "keywords": [r"\breact\b", r"\breactjs\b", r"\bnext\.?js\b", r"\bvue\b", r"\bvuejs\b",
                     r"\bangular\b", r"\btailwind\b", r"\btailwindcss\b", r"\bsvelte\b",
                     r"\bexpress\b", r"\bnode\.?js\b", r"\btypescript\b", r"\bjavascript\b",
                     r"\bpython\b", r"\bdjango\b", r"\bflask\b", r"\bfastapi\b",
                     r"\blibrary\b", r"\bframework\b", r"\bapi\b", r"\bdocs\b",
                     r"\bhooks?\b", r"\bcomponents?\b"],
        "instruction": "Use context7___resolve-library-id and context7___query-docs to fetch up-to-date documentation before answering."
    },
    # AWS Pricing (priority over aws-knowledge when pricing detected)
    "aws-pricing": {
        "keywords": AWS_PRICING_KEYWORDS,
        "instruction": "Use aws-pricing___get_pricing tools to fetch actual AWS pricing data."
    },
    # AWS Knowledge (only when no pricing keywords or alongside pricing)
    "aws-knowledge": {
        "keywords": AWS_SERVICE_KEYWORDS,
        "instruction": "Use aws-knowledge___aws___search_documentation and aws-knowledge___aws___read_documentation to fetch AWS documentation."
    },
    # LocalStack
    "localstack": {
        "keywords": [r"\blocalstack\b", r"\bmock\s*aws\b", r"\btest locally\b",
                     r"\bdev\s*aws\b", r"\blocal\s*s3\b", r"\blocal\s*lambda\b"],
        "instruction": "Use localstack-mcp-server___localstack-aws-client and localstack-mcp-server___localstack-management for local AWS development."
    },
    # Supabase
    "supabase": {
        "keywords": [r"\bsupabase\b", r"\bpostgres(?:ql)?\b", r"\brealtime\s*database\b",
                     r"\bfirebase\s*alternative\b"],
        "instruction": "Use Supabase MCP tools for backend and database operations."
    },
    # Vercel
    "vercel": {
        "keywords": [r"\bvercel\b", r"\bnext\.?js\s*deploy\b", r"\bserverless\s*frontend\b"],
        "instruction": "Use Vercel MCP tools for deployment and serverless operations."
    },
    # Playwright
    "playwright": {
        "keywords": [r"\bplaywright\b", r"\be2e\s*test\b", r"\bbrowser\s*test\b",
                     r"\bend-to-end\b", r"\bscraping\b", r"\bautomation\b", r"\bscreenshot\b"],
        "instruction": "Use playwright___browser_* tools for browser automation and testing."
    },
    # Chrome DevTools
    "chrome-devtools": {
        "keywords": [r"\bchrome\s*devtools\b", r"\bdebug\b", r"\binspect\b", r"\bdevtools\b"],
        "instruction": "Use chrome-devtools___* tools for browser debugging and inspection."
    },
    # GitHub
    "github": {
        "keywords": [r"\bgithub\b", r"\brepo\b", r"\bgit\b", r"\bpr\b", r"\bpull\s*request\b",
                     r"\bissue\b", r"\bcommit\b", r"\bbranch\b", r"\bci/cd\b"],
        "instruction": "Use github___* tools (create_issue, create_pull_request, search_repos, etc.) for GitHub operations."
    },
    # Firebase
    "firebase": {
        "keywords": [r"\bfirebase\b", r"\bfirestore\b", r"\bgoogle\s*auth\b", r"\bfcm\b",
                     r"\bfirebase\s*storage\b"],
        "instruction": "Use firebase___* tools for Firebase operations."
    },
    # Memory
    "memory": {
        "keywords": [r"\bremember\b", r"\brecall\b", r"\bsave\s*memory\b", r"\bstore\s*context\b",
                     r"\bprevious\s*session\b"],
        "instruction": "Use memory___* tools (create_entities, search_nodes, open_nodes) to store and retrieve information."
    },
    # Sequential Thinking
    "sequential-thinking": {
        "keywords": [r"\bthink\s*step\s*by\s*step\b", r"\banalyze\s*deeply\b",
                     r"\bcomplex\s*problem\b", r"\breasoning\b"],
        "instruction": "Use sequential-thinking___sequentialthinking tools for structured problem analysis."
    },
    # DrawIO
    "drawio": {
        "keywords": [r"\bdrawio\b", r"\bdiagram\b", r"\barchitecture\s*diagram\b", r"\bflowchart\b"],
        "instruction": "Use drawio-mcp___* tools for creating and editing diagrams."
    },
    # Flutter
    "flutter": {
        "keywords": [r"\bflutter\b", r"\bdart\b", r"\bflutter\s*sdk\b", r"\bflutter\s*app\b"],
        "instruction": "Use flutter/skills (e.g., flutter-testing-apps, flutter-managing-state, flutter-routing-and-navigation) based on the task before responding."
    },
    
    # Droid TTS - Text to Speech
    "droid-tts": {
        "keywords": [r"\btts\b", r"\bspeak\b", r"\bvoice\b", r"\bhablar\b", r"\bvoz\b",
                     r"\btext\s*to\s*speech\b", r"\baudio\b"],
        "instruction": "Use the droid-speak.sh script to make Droid speak. Execute: /Users/asuresky/.factory/hooks/droid-speak.sh \"message\""
    },
    
    # Git Release Flow
    "git-release": {
        "keywords": [r"\brelease\b", r"\bpublish\b", r"\bship\s*it\b", r"\bdeploy\s*version\b", r"\bcreate\s*release\b"],
        "instruction": "Use git-release-flow skill for automated release workflow with GitHub integration."
    },
}

def detect_aws_keywords(prompt: str) -> tuple[bool, bool]:
    """
    Detect AWS keywords in prompt.
    Returns: (has_pricing_keywords, has_service_keywords)
    """
    prompt_lower = prompt.lower()
    
    has_pricing = any(re.search(pattern, prompt_lower, re.IGNORECASE) for pattern in AWS_PRICING_KEYWORDS)
    has_services = any(re.search(pattern, prompt_lower, re.IGNORECASE) for pattern in AWS_SERVICE_KEYWORDS)
    
    return has_pricing, has_services

def detect_mcp_keywords(prompt: str) -> list[dict]:
    """Detect MCP-related keywords in the prompt and return matching MCP instructions."""
    prompt_lower = prompt.lower()
    detected = []
    
    # Special handling for AWS - separate pricing from services
    has_pricing, has_services = detect_aws_keywords(prompt)
    
    if has_pricing:
        # If pricing detected, always include aws-pricing
        detected.append({
            "mcp": "aws-pricing",
            "instruction": MCP_KEYWORDS["aws-pricing"]["instruction"]
        })
        # Also include aws-knowledge for pricing documentation
        if has_services:
            detected.append({
                "mcp": "aws-knowledge", 
                "instruction": "Use aws-knowledge___aws___search_documentation and aws-knowledge___aws___read_documentation to fetch AWS pricing documentation."
            })
    elif has_services:
        # Only services, no pricing - use aws-knowledge only
        detected.append({
            "mcp": "aws-knowledge",
            "instruction": MCP_KEYWORDS["aws-knowledge"]["instruction"]
        })
    
    # Check other MCPs (non-AWS)
    for mcp_name, config in MCP_KEYWORDS.items():
        # Skip aws-knowledge and aws-pricing as handled above
        if mcp_name in ("aws-knowledge", "aws-pricing"):
            continue
            
        for pattern in config["keywords"]:
            if re.search(pattern, prompt_lower, re.IGNORECASE):
                detected.append({
                    "mcp": mcp_name,
                    "instruction": config["instruction"]
                })
                break  # Only add each MCP once

    return detected

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

    prompt = input_data.get("prompt", "")

    if not prompt:
        sys.exit(0)

    # Detect keywords
    detected_mcps = detect_mcp_keywords(prompt)
    debug = os.getenv("MCP_DETECTOR_DEBUG", "").lower() in {"1", "true", "yes"}
    if debug:
        print(
            f"[MCP DEBUG] prompt={prompt!r} detected={[item['mcp'] for item in detected_mcps]}",
            file=sys.stderr,
        )

    if detected_mcps:
        # Build context injection
        context_lines = ["\n[MCP AUTO-INVOKE INSTRUCTIONS]"]
        context_lines.append("The following MCP tools should be used based on detected keywords:")

        for item in detected_mcps:
            context_lines.append(f"- {item['mcp'].upper()}: {item['instruction']}")

        context_lines.append("\nPlease invoke the appropriate MCP tools before responding.\n")

        # Output context (exit code 0 with stdout injects context for UserPromptSubmit)
        print("\n".join(context_lines))

    sys.exit(0)

if __name__ == "__main__":
    main()
