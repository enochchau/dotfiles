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
	stylua .
	for f in $(FNL_FILES)
	do
		echo "Formatting: $$f"
		fnlfmt --fix $$f
	done

.ONESHELL:
$(LUA_DIR)/%.lua: $(FNL_DIR)/%.fnl
		temp_file='/tmp/nvim_fnl_compile'
		if fennel --compile $< > $$temp_file; then
			cat $$temp_file > $@
		fi
		rm $$temp_file

.PHONY: quotes.json
quotes.json:
	./scripts/nppp_quotes.sh

.PHONY: clean
clean:
	rm $(LUA_FILES)
