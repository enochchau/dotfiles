.PHONY: fmt user

fmt:
	nixpkgs-fmt . && stylua .

user:
	./gen_user.sh $(git_username) $(git_email)
