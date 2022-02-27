user.nix:
	./scripts/gen_user.sh $(git_username) $(git_email) > user.nix

.PHONY: fmt install-part1 install-part2 install node

fmt:
	nixpkgs-fmt . && stylua . && prettier . -w

install:
	echo "run 'make install-part1' to install nix\nthen restart your shell and run 'make install-part2' to install home-manager"

install-part1:
	./scripts/install-nix.sh

install-part2: user.nix
	./scripts/install-home-manager.sh

nodejs/node-env.nix nodejs/node-packages.nix nodejs/default.nix: nodejs/node-packages.json
	cd nodejs && node2nix -i node-packages.json

node: nodejs/node-env.nix nodejs/node-packages.nix nodejs/default.nix
