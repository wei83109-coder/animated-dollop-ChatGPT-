"""Command line interface for YouTube plugin tooling."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any, Dict

from .manifest import Manifest, write_template


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Utilities to scaffold and validate YouTube plugin manifests.",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    init_parser = subparsers.add_parser("init", help="Generate a starter manifest file")
    init_parser.add_argument("path", type=Path, help="Where to write the manifest (JSON)")

    validate_parser = subparsers.add_parser("validate", help="Validate an existing manifest")
    validate_parser.add_argument("path", type=Path, help="Path to the manifest JSON file")

    return parser


def handle_init(path: Path) -> Path:
    return write_template(path)


def handle_validate(path: Path) -> Dict[str, Any]:
    manifest = Manifest.from_file(path)
    return {
        "name": manifest.name,
        "entry_point": manifest.entry_point,
        "permissions": manifest.permissions,
        "extra_keys": sorted(manifest.extra.keys()),
    }


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    if args.command == "init":
        target = handle_init(args.path)
        print(f"Template written to {target}")
    elif args.command == "validate":
        summary = handle_validate(args.path)
        print(json.dumps(summary, indent=2))
    else:
        parser.error("Unknown command")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
