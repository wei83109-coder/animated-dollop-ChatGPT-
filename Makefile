.PHONY: setup test automation ci

setup:
	python -m venv .venv
	. .venv/bin/activate && pip install -r requirements.txt

test:
	python -m pytest

automation:
	python -m automation.tasks verify

ci: test automation
