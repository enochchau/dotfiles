SHELL := /bin/bash

# fennel files
FNL_SRC := $(shell find fnl -name '*.fnl')
# lua files
LUA_SRC := $(patsubst fnl/%,lua/%,$(patsubst %.fnl,%.lua,$(FNL_SRC)))

.PHONY: all
all: $(LUA_SRC)

.PHONY: fmt
.ONESHELL:
fmt:
	stylua .
	for f in $(FNL_SRC)
	do
		fnlfmt --fix $$f
	done

.ONESHELL:
$(LUA_SRC): $(FNL_SRC)
	fnl=( $(FNL_SRC) )
	lua=( $(LUA_SRC) )
	for i in "$${!fnl[@]}"; do
		if fennel --compile "$${fnl[$$i]}" > _tmp
		then
			cat _tmp > "$${lua[$$i]}"
		fi
		rm _tmp

	done

quotes.json:
	./nppp_quotes.sh

.PHONY: clean
clean:
	rm $(LUA_SRC)
