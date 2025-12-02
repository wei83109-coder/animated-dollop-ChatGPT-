import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]


def test_top_level_layout_created():
    expected_dirs = [
        ROOT / "src",
        ROOT / "src" / "frontend",
        ROOT / "src" / "frontend" / "assets",
        ROOT / "src" / "backend",
        ROOT / "src" / "backend" / "api",
        ROOT / "configs",
        ROOT / "tests",
    ]

    for path in expected_dirs:
        assert path.is_dir(), f"Missing expected directory: {path}"


def test_readme_mentions_playground_and_tests():
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    assert "src/frontend/GitHubStarter.playground" in readme
    assert "pytest" in readme


def test_refresh_rate_doc_exists():
    path = ROOT / "configs" / "REFRESH_RATE.md"
    assert path.is_file(), "REFRESH_RATE.md should be present to guide high-motion views"
    contents = path.read_text(encoding="utf-8")
    assert "80Hz" in contents and "120Hz" in contents


def test_playground_scaffold_present():
    playground = ROOT / "src" / "frontend" / "GitHubStarter.playground"
    assert playground.is_dir()
    contents = playground / "Contents.swift"
    assert contents.is_file()
    text = contents.read_text(encoding="utf-8")
    assert "GitHubStarterView" in text
    assert "PlaygroundPage.current.setLiveView" in text


def test_backend_api_doc_exists():
    path = ROOT / "src" / "backend" / "api" / "README.md"
    assert path.is_file(), "API area should be documented to keep backend concerns organized"
    text = path.read_text(encoding="utf-8")
    assert "NovaFlux" in text


def test_roadmap_exists():
    path = ROOT / "ROADMAP.md"
    assert path.is_file(), "ROADMAP.md should remain available for contributors"
