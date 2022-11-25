# fennel files
FNL_SRC := $(shell find fnl -name '*.fnl')
# lua files
LUA_SRC := $(patsubst fnl/%,lua/%,$(patsubst %.fnl,%.lua,$(FNL_SRC)))

.PHONY: all
all: $(LUA_SRC)

.PHONY: fmt
fmt:
	stylua . & fnlfmt --fix $(FNL_SRC)

$(LUA_SRC): $(FNL_SRC)
	fennel --compile $< > $@

.PHONY: clean
clean:
	rm $(LUA_SRC)
