SHELL := /bin/bash

# fennel files
FNL_SRC := $(shell find fnl -name '*.fnl')
# lua files
LUA_SRC := $(patsubst fnl/%,lua/%,$(patsubst %.fnl,%.lua,$(FNL_SRC)))

.PHONY: all
all: $(LUA_SRC)

.PHONY: fmt
fmt:
	stylua . & fnlfmt --fix $(FNL_SRC)

.ONESHELL:
$(LUA_SRC): $(FNL_SRC)
	fnl=()
	for f in $(FNL_SRC); do
		fnl+=($$f)
	done
	lua=()
	for l in $(LUA_SRC); do
		lua+=($$l)
	done
	for i in "$${!fnl[@]}"; do
		fennel --compile "$${fnl[$$i]}" > "$${lua[$$i]}"
	done

quotes.json:
	./nppp_quotes.sh

.PHONY: clean
clean:
	rm $(LUA_SRC)
