install:
	if ! command -v ansible &>/dev/null ; then pip3 install ansible ; fi
.PHONY: install

part1: install
	ansible-playbook --ask-become-pass -i hosts local.yml --tags "part1"
.PHONY: part1

tag:
	ansible-playbook --ask-become-pass -i hosts local.yml --tags $(TAG)

update:
	ansible-playbook --ask-become-pass -i hosts local.yml
.PHONY: update

lint:
	ansible-lint
.PHONY: lint

fmt:
	prettier . --write
.PHONY: fmt
