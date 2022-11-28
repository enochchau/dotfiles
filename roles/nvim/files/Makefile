SHELL := /bin/bash

FNL_DIR := $(shell find . -name '*.fnl' -exec dirname "{}" \; | uniq)
FNL_FILES := $(foreach dir,$(FNL_DIR),$(wildcard $(dir)/*.fnl))

LUA_DIR := $(patsubst ./fnl/%,./lua/%,$(FNL_DIR))
LUA_FILES := $(patsubst ./fnl/%,lua/%,$(patsubst %.fnl,%.lua,$(FNL_FILES)))

.PHONY: all
all: $(LUA_FILES) .styluaignore

# build lua files
$(LUA_DIR)/%.lua: $(FNL_DIR)/%.fnl
	FENNEL_COMPILE=true nvim --headless -c 'FnlCompile $< $@' +q

.styluaignore: $(LUA_FILES)
	echo -e "plugin/packer_compiled.lua\nlua/bulb/fennel.lua" > .styluaignore ;\
	$(foreach file,$(LUA_FILES),echo $(file) >> .styluaignore;)

# clean lua files
.PHONY: clean
clean:
	rm $(LUA_FILES) .styluaignore

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
