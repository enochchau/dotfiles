SHELL := /bin/bash

FNL_DIR := $(shell find ./ -name '*.fnl' -exec dirname "{}" \; | uniq)
FNL_FILES := $(foreach dir,$(FNL_DIR),$(wildcard $(dir)/*.fnl))

LUA_DIR := $(patsubst ./fnl/%,./lua/%,$(FNL_DIR))
LUA_FILES := $(patsubst ./fnl/%,./lua/%,$(patsubst %.fnl,%.lua,$(FNL_FILES)))

.PHONY: all
all: $(LUA_FILES) fmt

.PHONY: fmt
.ONESHELL:
fmt:
	omit_lua=( $(LUA_FILES) plugin/packer_compiled.lua lua/bulb/fennel.lua )
	omit_glob=$$(printf ",!%s" "$${omit_lua[@]}")
	omit_glob="{./**/*.lua$${omit_glob}}"
	stylua --glob "$$omit_glob" .
	for f in $(FNL_FILES)
	do
		echo "Formatting: $$f"
		fnlfmt --fix $$f
	done

.ONESHELL:
$(LUA_DIR)/%.lua: $(FNL_DIR)/%.fnl
	FENNEL_COMPILE=true nvim --headless -c 'FnlCompile $< $@' +q

.PHONY: quotes.json
quotes.json:
	./scripts/nppp_quotes.sh

.PHONY: clean
clean:
	rm $(LUA_FILES)

