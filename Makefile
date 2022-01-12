update:
	git submodule update --remote dotbot \
	&& curl -L git.io/antigen > antigen.zsh

link:
	./install
