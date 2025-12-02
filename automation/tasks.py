from __future__ import annotations

import argparse
import json
import os
import pathlib
from dataclasses import dataclass
from typing import Iterable
from urllib.parse import urljoin, urlparse

ROOT = pathlib.Path(__file__).resolve().parents[1]
RESOURCES = ROOT / "GitHubStarter.playground" / "Resources"
DEFAULT_BASE = "https://api.novaflux.example/v1"
DEFAULT_KEY = "nova-demo-key-please-replace"


@dataclass
class CheckResult:
    name: str
    passed: bool
    detail: str


def _sanitize_base_url(raw_value: str) -> str:
    parsed = urlparse(raw_value)
    if parsed.scheme and parsed.netloc:
        return raw_value.rstrip("/")
    return DEFAULT_BASE


def validate_repository() -> list[CheckResult]:
    checks: list[CheckResult] = []

    readme = ROOT / "README.md"
    if readme.is_file():
        contents = readme.read_text(encoding="utf-8")
        has_playground = "GitHubStarter.playground" in contents
        has_pytest = "pytest" in contents
        checks.append(
            CheckResult(
                name="README.md",
                passed=has_playground and has_pytest,
                detail="README includes playground reference and testing instructions",
            )
        )
    else:
        checks.append(CheckResult(name="README.md", passed=False, detail="README missing"))

    for path, description in [
        (ROOT / "REFRESH_RATE.md", "refresh-rate guidance present"),
        (ROOT / "ROADMAP.md", "roadmap present"),
        (ROOT / "GitHubStarter.playground" / "Contents.swift", "playground entry present"),
    ]:
        checks.append(
            CheckResult(
                name=str(path.relative_to(ROOT)),
                passed=path.is_file(),
                detail=description,
            )
        )

    for resource in ["pr_review_checklist.md", "notification_triage_prompt.md"]:
        target = RESOURCES / resource
        checks.append(
            CheckResult(
                name=str(target.relative_to(ROOT)),
                passed=target.is_file(),
                detail="quick-action prompt available",
            )
        )

    return checks


def build_novaflux_request(prompt: str, *, base_url: str | None = None, api_key: str | None = None) -> dict:
    base = _sanitize_base_url(base_url or os.environ.get("NOVFLUX_API_BASE", DEFAULT_BASE))
    key = api_key or os.environ.get("NOVFLUX_API_KEY", DEFAULT_KEY)

    url = urljoin(f"{base}/", "automations")
    headers = {
        "Authorization": f"Bearer {key}",
        "Content-Type": "application/json",
    }
    body = {
        "intent": "mobile-github-assistant",
        "prompt": prompt,
        "device": "automation-cli",
    }
    return {"url": url, "headers": headers, "body": body}


def list_quick_actions() -> list[dict]:
    actions: list[dict] = []
    if not RESOURCES.exists():
        return actions

    for path in sorted(RESOURCES.glob("*.md")):
        actions.append({"name": path.stem, "payload": path.read_text(encoding="utf-8").strip()})
    return actions


def _print_check_results(results: Iterable[CheckResult], as_json: bool = False) -> None:
    if as_json:
        print(json.dumps([result.__dict__ for result in results], indent=2))
        return

    for result in results:
        status = "✅" if result.passed else "❌"
        print(f"{status} {result.name}: {result.detail}")


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description="Automation utilities for the GitHubStarter repo")
    subparsers = parser.add_subparsers(dest="command", required=True)

    verify_parser = subparsers.add_parser("verify", help="Validate repository structure")
    verify_parser.add_argument("--json", dest="emit_json", action="store_true", help="Emit JSON results")

    nova_parser = subparsers.add_parser("novaflux", help="Preview the NovaFlux request")
    nova_parser.add_argument("prompt", help="Prompt to send to NovaFlux")
    nova_parser.add_argument("--base", dest="base_url", help="Override the base URL")
    nova_parser.add_argument("--key", dest="api_key", help="Override the API key")

    subparsers.add_parser("actions", help="List bundled quick actions")

    args = parser.parse_args(argv)

    if args.command == "verify":
        results = validate_repository()
        _print_check_results(results, as_json=args.emit_json)
        exit_code = 0 if all(result.passed for result in results) else 1
        raise SystemExit(exit_code)

    if args.command == "novaflux":
        request = build_novaflux_request(args.prompt, base_url=args.base_url, api_key=args.api_key)
        print(json.dumps(request, indent=2))
        raise SystemExit(0)

    if args.command == "actions":
        actions = list_quick_actions()
        print(json.dumps(actions, indent=2))
        raise SystemExit(0)


if __name__ == "__main__":
    main()
