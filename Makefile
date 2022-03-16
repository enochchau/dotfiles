PHONY: install

install:
	if ! which ansible &>/dev/null ; then pip3 install ansible ; fi

upgrade: install
	ansible-playbook --ask-become-pass -i hosts local.yml
