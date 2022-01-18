update:
	git submodule update --remote dotbot \
		&& ./scripts/sheldon_install.zsh

link:
	./install

macos:
	./scripts/macos.sh

linux:
	./scripts/linux.sh
