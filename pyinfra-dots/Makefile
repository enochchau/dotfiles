.PHONY: run lint format typecheck check

run:
	uv run pyinfra @local deploy.py

lint:
	uv run ruff check .

format:
	uv run ruff format .

typecheck:
	uv run ty check .

check: lint format typecheck
