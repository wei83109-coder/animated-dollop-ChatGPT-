from pathlib import Path
import json
import pytest

from youtube_plugin_tools.manifest import Manifest, generate_template, write_template


def test_generate_template_returns_copy():
    first = generate_template()
    second = generate_template()
    assert first == second
    assert first is not second


def test_manifest_validation_success(tmp_path: Path):
    manifest_path = tmp_path / "manifest.json"
    content = generate_template()
    manifest_path.write_text(json.dumps(content), encoding="utf-8")

    manifest = Manifest.from_file(manifest_path)

    assert manifest.name == content["name"]
    assert manifest.permissions == content["permissions"]
    assert manifest.quality_profile == content["quality_profile"]
    assert manifest.extra == {}


def test_manifest_validation_missing_required_field():
    payload = generate_template()
    payload.pop("name")
    with pytest.raises(ValueError) as excinfo:
        Manifest.from_dict(payload)
    assert "missing required fields" in str(excinfo.value)


def test_manifest_rejects_invalid_permissions():
    payload = generate_template()
    payload["permissions"] = ["", 123]
    with pytest.raises(ValueError) as excinfo:
        Manifest.from_dict(payload)
    assert "permissions" in str(excinfo.value)


def test_manifest_rejects_invalid_quality_profile():
    payload = generate_template()
    payload["quality_profile"] = {"audio": "bad", "video": "360p"}
    with pytest.raises(ValueError) as excinfo:
        Manifest.from_dict(payload)
    assert "quality_profile" in str(excinfo.value)


def test_write_template_creates_file(tmp_path: Path):
    target = tmp_path / "nested" / "manifest.json"
    write_template(target)
    assert target.exists()
    data = json.loads(target.read_text(encoding="utf-8"))
    assert data == generate_template()
