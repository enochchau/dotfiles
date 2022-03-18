.PHONY: install update part1

install:
	if ! which ansible &>/dev/null ; then pip3 install ansible ; fi

part1: install
	ansible-playbook --ask-become-pass -i hosts local.yml --tags "part1"

update:
	ansible-playbook --ask-become-pass -i hosts local.yml
