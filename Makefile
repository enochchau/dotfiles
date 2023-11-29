update:
	ansible-playbook --ask-become-pass -i hosts local.yml
.PHONY: update

install-deps:
	ansible-galaxy collection install -r requirements.yml
.PHONY: install-deps

tag:
	ansible-playbook --ask-become-pass -i hosts local.yml --tags $(TAG)
.PHONY: tags

lint:
	ansible-lint
.PHONY: lint

fmt:
	prettier . --write
.PHONY: fmt
