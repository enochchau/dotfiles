update:
	ansible-playbook --ask-become-pass -i hosts local.yml
.PHONY: update

install:
	if ! command -v ansible &>/dev/null ; then python3 -m pip install ansible; fi
.PHONY: install

install-deps:
	ansible-galaxy collection install -r requirements.yml
.PHONY: install-deps

part1:
	ansible-playbook --ask-become-pass -i hosts local.yml --tags "part1"
.PHONY: part1

tag:
	ansible-playbook --ask-become-pass -i hosts local.yml --tags $(TAG)
.PHONY: tags

lint:
	ansible-lint
.PHONY: lint

fmt:
	prettier . --write
.PHONY: fmt
