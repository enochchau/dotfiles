update:
	git submodule update --remote dotbot \
		&& ./scripts/sheldon_install.zsh

link:
	./install

neovim:
	./scripts/nvim_install.sh
