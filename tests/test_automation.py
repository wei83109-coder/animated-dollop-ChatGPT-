from automation.tasks import build_novaflux_request, list_quick_actions, validate_repository


def test_validate_repository_passes():
    results = validate_repository()
    assert results, "Validation should return checks"
    assert all(result.passed for result in results)
    names = {result.name for result in results}
    assert "README.md" in names
    assert "GitHubStarter.playground/Contents.swift" in names


def test_build_novaflux_request_appends_path():
    payload = build_novaflux_request("hello")
    assert payload["url"].endswith("/automations")
    assert payload["body"]["prompt"] == "hello"
    assert "Authorization" in payload["headers"]


def test_list_quick_actions_reads_resources():
    actions = list_quick_actions()
    names = {action["name"] for action in actions}
    assert "pr_review_checklist" in names
    assert "notification_triage_prompt" in names
