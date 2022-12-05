SHELL := /bin/bash

FNL_FILES := $(shell find . -name '*.fnl' -type f | sort)

# format lua and fennel files
.PHONY: fmt
fmt:
	stylua .; $(foreach file,$(FNL_FILES),echo "Formatting " $(file); fnlfmt --fix $(file);)

# fetch notepad ++ quotes
.PHONY: quotes.json
quotes.json:
	./scripts/nppp_quotes.sh

# update fennel version to latest
.PHONY: update_fennel
update_fennel:
	./scripts/update_fennel.sh
