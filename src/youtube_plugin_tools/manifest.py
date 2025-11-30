"""Utilities for defining and validating YouTube plugin manifests."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List
import json

REQUIRED_FIELDS = {"name", "description", "version", "author", "entry_point"}
OPTIONAL_FIELDS = {"permissions", "quality_profile"}


@dataclass
class Manifest:
    """Represents a YouTube plugin manifest."""

    name: str
    description: str
    version: str
    author: str
    entry_point: str
    permissions: List[str] = field(default_factory=list)
    quality_profile: Dict[str, str] = field(default_factory=dict)
    extra: Dict[str, Any] = field(default_factory=dict)

    @classmethod
    def from_dict(cls, payload: Dict[str, Any]) -> "Manifest":
        cls._validate_structure(payload)
        extra_keys = set(payload) - (REQUIRED_FIELDS | OPTIONAL_FIELDS)
        extra = {key: payload[key] for key in extra_keys}
        return cls(
            name=payload["name"],
            description=payload["description"],
            version=payload["version"],
            author=payload["author"],
            entry_point=payload["entry_point"],
            permissions=payload.get("permissions", []),
            quality_profile=payload.get("quality_profile", {}),
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

        if "quality_profile" in payload:
            Manifest._validate_quality_profile(payload["quality_profile"])

    @staticmethod
    def _validate_quality_profile(profile: Any) -> None:
        if not isinstance(profile, dict):
            raise ValueError("'quality_profile' must be a dictionary")

        allowed_audio = {"lossless", "high"}
        allowed_video = {"8k", "4k", "1080p"}

        audio = profile.get("audio")
        video = profile.get("video")

        if not isinstance(audio, str) or audio not in allowed_audio:
            raise ValueError("'quality_profile.audio' must be one of: lossless, high")

        if not isinstance(video, str) or video not in allowed_video:
            raise ValueError("'quality_profile.video' must be one of: 8k, 4k, 1080p")


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
    "quality_profile": {
        "audio": "lossless",
        "video": "8k",
    },
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
