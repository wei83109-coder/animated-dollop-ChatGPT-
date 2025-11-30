# YouTube Plugin Tools

A minimal toolkit for a YouTube plugin engineering team. It helps you scaffold a plugin manifest, keep required metadata consistent, and validate JSON before shipping an integration to customers or the YouTube platform.

## Features
- Generate a starter manifest JSON with required fields and sensible defaults.
- Validate manifests to ensure all required fields are present and well-formed.
- Simple CLI for initializing and checking manifest files.

## Getting started
1. Ensure Python 3.10+ is installed.
2. Install dependencies:
   ```bash
   python -m pip install -e .[dev]
   ```

## Usage
Generate a starter manifest:
```bash
python -m youtube_plugin_tools.cli init manifest.json
```

Validate an existing manifest:
```bash
python -m youtube_plugin_tools.cli validate manifest.json
```

## Automated tests
Run the test suite with pytest:
```bash
python -m pytest
```

The tests cover manifest validation rules and file generation helpers to ensure the repository stays reliable.
