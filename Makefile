.PHONY: run
run:
	uv run pyinfra @local deploy.py

.PHONY: run-symlink-only
run-symlink-only:
	DOTFILES_MODE=symlink-only uv run pyinfra @local deploy.py

.PHONY: lint
lint:
	uv run ruff check .

.PHONY: format
format:
	uv run ruff format .

.PHONY: typecheck
typecheck:
	uv run ty check .

.PHONY: check
check: lint format typecheck
