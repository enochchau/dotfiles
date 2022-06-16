.PHONY: install update part1 lint fmt

install:
	if ! command -v ansible &>/dev/null ; then pip3 install ansible ; fi

part1: install
	ansible-playbook --ask-become-pass -i hosts local.yml --tags "part1"

update:
	ansible-playbook --ask-become-pass -i hosts local.yml

lint:
	ansible-lint

fmt:
	prettier . --write
