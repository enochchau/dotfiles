.PHONY: install upgrade

install:
	if ! which ansible &>/dev/null ; then pip3 install ansible ; fi

part1: install
	ansible-playbook --ask-become-pass -i hosts local.yml --tags "zsh"

update:
	ansible-playbook --ask-become-pass -i hosts local.yml
