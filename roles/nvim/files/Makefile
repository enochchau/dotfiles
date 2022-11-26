SHELL := /bin/bash

FNL_DIR := $(shell find ./ -name '*.fnl' -exec dirname "{}" \; | uniq)
FNL_FILES := $(foreach dir,$(FNL_DIR),$(wildcard $(dir)/*.fnl))

LUA_DIR := $(patsubst ./fnl/%,./lua/%,$(FNL_DIR))
LUA_FILES := $(patsubst ./fnl/%,./lua/%,$(patsubst %.fnl,%.lua,$(FNL_FILES)))

.PHONY: all
all: $(LUA_FILES)

# build lua files
.ONESHELL:
$(LUA_DIR)/%.lua: $(FNL_DIR)/%.fnl
	FENNEL_COMPILE=true nvim --headless -c 'FnlCompile $< $@' +q
	if ! grep -q $@ .styluaignore ; then
		echo $@ >> .styluaignore
	fi

# clean lua files
.PHONY: clean
clean:
	rm $(LUA_FILES)

# format lua and fennel files
.PHONY: fmt
fmt:
	stylua .; $(foreach file,$(FNL_FILES),echo "Formatting " $(file); fnlfmt --fix $(file);)

# fetch notepad ++ quotes
.PHONY: quotes.json
quotes.json:
	./scripts/nppp_quotes.sh

# update fennel version to latest
.ONESHELL:
.PHONY: update_fennel
update_fennel:
	./scripts/update_fennel.sh
