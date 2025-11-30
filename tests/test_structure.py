import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]


def test_readme_mentions_playground_and_tests():
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    assert "GitHubStarter.playground" in readme
    assert "pytest" in readme


def test_refresh_rate_doc_exists():
    path = ROOT / "REFRESH_RATE.md"
    assert path.is_file(), "REFRESH_RATE.md should be present to guide high-motion views"
    contents = path.read_text(encoding="utf-8")
    assert "80Hz" in contents and "120Hz" in contents


def test_playground_scaffold_present():
    playground = ROOT / "GitHubStarter.playground"
    assert playground.is_dir()
    contents = playground / "Contents.swift"
    assert contents.is_file()
    text = contents.read_text(encoding="utf-8")
    assert "GitHubStarterView" in text
    assert "PlaygroundPage.current.setLiveView" in text


def test_roadmap_exists():
    path = ROOT / "ROADMAP.md"
    assert path.is_file(), "ROADMAP.md should remain available for contributors"
