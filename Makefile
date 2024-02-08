# var
MODULE  = $(notdir $(CURDIR))

# version
MAPMAP_VER = 0.6.2

# dir
CWD  = $(CURDIR)
BIN  = $(CWD)/bin
INC  = $(CWD)/inc
SRC  = $(CWD)/src
TMP  = $(CWD)/tmp
REF  = $(CWD)/ref
GZ   = $(HOME)/gz

# tool
CURL = curl -L -o
CF   = clang-format

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

# cfg
CFLAGS += -I$(INC) -I$(TMP)

# package
MAPMAP    = mapmap-$(MAPMAP_VER)
MAPMAP_GZ = $(MAPMAP).tar.gz

# all
.PHONY: all
all: $(REF)/$(MAPMAP)/mapmap.pro
	cd $(REF)/$(MAPMAP) ; qmake $<

# format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(D)
	$(CF) -style=file -i $? && touch $@

# rule
bin/$(MODULE): $(MODULE).mk $(C) $(H)
	make -f $<
# $(CXX) $(CFLAGS) -o $@ $(C) $(L)

$(MODULE).mk: $(MODULE).pro
	qmake $< -o $@

# doc
.PHONY: doc
doc:

# install
.PHONY: install update gz ref
install: doc gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -yu `cat apt.txt`
gz: \
	ref
ref: \
	$(REF)/$(MAPMAP)/mapmap.pro

$(REF)/$(MAPMAP)/mapmap.pro: $(GZ)/$(MAPMAP_GZ)
	cd ref ; tar zx < $< && touch $@

$(GZ)/$(MAPMAP_GZ):
	$(CURL) $@ https://github.com/mapmapteam/mapmap/archive/refs/tags/$(MAPMAP_VER).tar.gz
