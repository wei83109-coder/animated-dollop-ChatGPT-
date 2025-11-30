"""Utilities for defining and validating YouTube plugin manifests."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List
import json

REQUIRED_FIELDS = {"name", "description", "version", "author", "entry_point"}


@dataclass
class Manifest:
    """Represents a YouTube plugin manifest."""

    name: str
    description: str
    version: str
    author: str
    entry_point: str
    permissions: List[str] = field(default_factory=list)
    extra: Dict[str, Any] = field(default_factory=dict)

    @classmethod
    def from_dict(cls, payload: Dict[str, Any]) -> "Manifest":
        cls._validate_structure(payload)
        extra_keys = set(payload) - (REQUIRED_FIELDS | {"permissions"})
        extra = {key: payload[key] for key in extra_keys}
        return cls(
            name=payload["name"],
            description=payload["description"],
            version=payload["version"],
            author=payload["author"],
            entry_point=payload["entry_point"],
            permissions=payload.get("permissions", []),
            extra=extra,
        )

    @classmethod
    def from_file(cls, path: Path | str) -> "Manifest":
        path = Path(path)
        with path.open("r", encoding="utf-8") as handle:
            payload = json.load(handle)
        return cls.from_dict(payload)

    @staticmethod
    def _validate_structure(payload: Dict[str, Any]) -> None:
        missing = REQUIRED_FIELDS - payload.keys()
        if missing:
            missing_list = ", ".join(sorted(missing))
            raise ValueError(f"Manifest is missing required fields: {missing_list}")

        for key in REQUIRED_FIELDS:
            if not isinstance(payload.get(key), str) or not payload[key].strip():
                raise ValueError(f"Field '{key}' must be a non-empty string")

        if "permissions" in payload:
            if not isinstance(payload["permissions"], list) or not all(
                isinstance(item, str) and item.strip() for item in payload["permissions"]
            ):
                raise ValueError("'permissions' must be a list of non-empty strings")


DEFAULT_TEMPLATE: Dict[str, Any] = {
    "name": "Sample YouTube Plugin",
    "description": "Describe what your plugin does for YouTube creators or viewers.",
    "version": "0.1.0",
    "author": "Your Company",
    "entry_point": "plugin:handler",
    "permissions": [
        "youtube.readonly",
        "youtube.upload",
    ],
}


def generate_template() -> Dict[str, Any]:
    """Return a dictionary that can be saved as a starter manifest."""

    return DEFAULT_TEMPLATE.copy()


def write_template(path: Path | str) -> Path:
    """Write a starter manifest to the given path."""

    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(DEFAULT_TEMPLATE, handle, indent=2)
        handle.write("\n")
    return path
