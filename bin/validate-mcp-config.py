#!/usr/bin/env python3
import json
import os
import sys
from urllib.parse import urlparse


def load_json(path):
    try:
        with open(path, "r", encoding="utf-8") as handle:
            return json.load(handle)
    except FileNotFoundError:
        raise ValueError(f"Config not found: {path}")
    except json.JSONDecodeError as exc:
        raise ValueError(f"Invalid JSON in {path}: {exc}")


def add_error(errors, message):
    errors.append(message)


def scan_placeholders(value, path, errors):
    if isinstance(value, str) and "YOUR_" in value:
        add_error(errors, f"Placeholder not replaced at {path}: {value}")
    elif isinstance(value, list):
        for index, item in enumerate(value):
            scan_placeholders(item, f"{path}[{index}]", errors)
    elif isinstance(value, dict):
        for key, item in value.items():
            scan_placeholders(item, f"{path}.{key}", errors)


def validate_url(url, path, errors):
    parsed = urlparse(url)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        add_error(errors, f"Invalid URL at {path}: {url}")


def validate_server(name, server, errors):
    if not isinstance(server, dict):
        add_error(errors, f"mcpServers.{name} must be an object")
        return

    server_type = server.get("type")
    if server_type not in {"http", "stdio"}:
        add_error(errors, f"mcpServers.{name}.type must be 'http' or 'stdio'")
        return

    if "disabled" in server and not isinstance(server["disabled"], bool):
        add_error(errors, f"mcpServers.{name}.disabled must be boolean")

    if "headers" in server and not isinstance(server["headers"], dict):
        add_error(errors, f"mcpServers.{name}.headers must be an object")

    if "env" in server and not isinstance(server["env"], dict):
        add_error(errors, f"mcpServers.{name}.env must be an object")

    if server_type == "http":
        url = server.get("url")
        if not isinstance(url, str) or not url.strip():
            add_error(errors, f"mcpServers.{name}.url is required for http servers")
        else:
            validate_url(url, f"mcpServers.{name}.url", errors)
    else:
        command = server.get("command")
        if not isinstance(command, str) or not command.strip():
            add_error(errors, f"mcpServers.{name}.command is required for stdio servers")
        if "args" in server and not isinstance(server["args"], list):
            add_error(errors, f"mcpServers.{name}.args must be an array")


def validate_config(config, allow_placeholders):
    errors = []
    if not isinstance(config, dict):
        add_error(errors, "Root config must be an object")
        return errors

    servers = config.get("mcpServers")
    if not isinstance(servers, dict):
        add_error(errors, "mcpServers must be an object")
        return errors

    for name, server in servers.items():
        validate_server(name, server, errors)

    if not allow_placeholders:
        scan_placeholders(config, "root", errors)

    return errors


def main():
    args = sys.argv[1:]
    allow_placeholders = False
    path = os.path.expanduser("~/.factory/mcp.json")

    for arg in list(args):
        if arg == "--allow-placeholders":
            allow_placeholders = True
            args.remove(arg)

    if args:
        path = args[0]

    try:
        config = load_json(path)
    except ValueError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    errors = validate_config(config, allow_placeholders)
    if errors:
        for message in errors:
            print(f"Error: {message}", file=sys.stderr)
        return 1

    print(f"OK: {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
