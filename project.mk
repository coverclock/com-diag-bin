# vi: set ts=4 shiftwidth=4:
# Copyright 2021 Digital Aggregates Corporation, Arvada Colorado USA.
# Licensed under the terms in LICENSE.txt.
# author:Chip Overclock
# mailto:coverclock@diag.com
# https://github.com/coverclock/com-diag-XXXXXXXX
# "Chip Overclock" is a registered trademark.
# "Digital Aggregates Corporation" is a registered trademark.
#
#	make all TARGET=<target>		# Build libraries, unit tests, executable programs.
#
#	. out/host/bin/setup			# Sets up PATH and LD_LIBRARY_PATH after build.
#

.PHONY:	default

default:	all

########## Customizations

TITLE				:=	XXXXXXXX

MAJOR				:=	0# API changes that may require that applications be modified.
MINOR				:=	0# Only functionality or features added with no legacy API changes.
BUILD				:=	0# Only bugs fixed with no API changes or new functionality.

TARGET				:=	host# Build for the local host of the Makefile.

COPYRIGHT			:=	2021 Digital Aggregates Corporation
LICENSE				:=	GNU Lesser General Public License 2.1
CONTACT				:=	coverclock@diag.com
HOMEPAGE			:=	https://github.com/coverclock/com-diag-XXXXXXXX
HOST				:=	$(shell hostname -s)
BRANCH				:=	$(shell git rev-parse --abbrev-ref HEAD)
REVISION			:=	$(shell git rev-parse HEAD)
MODIFIED			:=	$(shell date -u -d @$(shell git log -1 --format="%at") +%Y-%m-%dT%H:%M:%S.%N%z)
ROOT				:=	$(shell git rev-parse --show-toplevel)
VINTAGE				:=	$(shell date -u +%Y-%m-%dT%H:%M:%S.%N%z)

HOME_DIR			:=	$(HOME)/Projects

########## Collateral

APP_DIR				:=	app# Application source directories
BIN_DIR				:=	bin# Utility source files
CFG_DIR				:=	cfg# Build configuration files
DAT_DIR				:=	dat# Saved datasets
ETC_DIR				:=	etc# Miscellaneous files
EXT_DIR				:=	ext# Extra source files not part of this IP
OLY_DIR				:=	oly# File system overlay
FUN_DIR				:=	fun# Functional tests
INC_DIR				:=	inc# Header files
SRC_DIR				:=	src# Library source files
TST_DIR				:=	tst# Unit tests
TXT_DIR				:=	txt# Miscellaneous text files

########## Artifacts

OUT_DIR				:=	out# Build artifacts
ARC_DIR				:=	arc# Archive files for static linking
DEP_DIR				:=	dep# Generated dependencies and other make files
DOC_DIR				:=	doc# Documentation
GEN_DIR				:=	gen# Generated utility source files
LIB_DIR				:=	lib# Shared objects for dynamic linking
MOD_DIR				:=	mod# Loadable user modules
OBC_DIR				:=	obc# C object modules
SYM_DIR				:=	sym# Unstripped executable binaries
TGZ_DIR				:=	tgz# Compressed tarballs

########## Configuration

PROJECT				:=	$(shell echo $(TITLE) | tr '[A-Z]' '[a-z]')
SYMBOL				:=	$(shell echo $(TITLE) | tr '[a-z]' '[A-Z]')

HERE				:=	$(shell pwd)
THERE				:=	$(shell realpath ../..)

OUT					:=	$(OUT_DIR)/$(TARGET)

TEMP_DIR			:=	/tmp
ROOT_DIR			:=	$(HOME_DIR)/$(TARGET)

GITURL				:=	https://github.com/coverclock/com-diag-$(PROJECT).git

GENERATED			:=	vintage generate setup
PROVIDENCED			:=	$(PROJECT)_release.c $(PROJECT)_vintage.c $(PROJECT)_revision.c
SYNTHESIZED			:=	$(PROJECT)_release.h $(PROJECT)_vintage.h $(PROJECT)_revision.h

ALIASES				:=	

NEW					:=	dummy
OLD					:=	dummy

PACKAGE				:=	$(OUT)/$(TGZ_DIR)/$(PROJECT)-$(TARGET)

MANIFEST			:=	$(APP_DIR) $(ARC_DIR) $(BIN_DIR) $(INC_DIR) $(LIB_DIR) $(MOD_DIR) $(TST_DIR) $(FUN_DIR)

DISTRIBUTION		:=	$(OUT)/$(TGZ_DIR)/$(PROJECT)-$(MAJOR).$(MINOR).$(BUILD)

TARBALL				:=	$(OUT)/$(TGZ_DIR)/$(PROJECT)

SO					:=	so

A2SOARCH			:=	-shared -Wl,-soname,lib$(PROJECT).$(SO).$(MAJOR).$(MINOR)

MODE				:= 755

########## Configuration Makefile

TARGETMAKEFILE		:= $(CFG_DIR)/$(TARGET).mk

-include $(TARGETMAKEFILE)

########## Diminuto Configuration

DIMINUTO_TITLE		:=	Diminuto

DIMINUTO_PROJECT	:=	$(shell echo $(DIMINUTO_TITLE) | tr '[A-Z]' '[a-z]')
DIMINUTO_SYMBOL		:=	$(shell echo $(DIMINUTO_TITLE) | tr '[a-z]' '[A-Z]')

DIMINUTO_ROOT		:=	$(THERE)/com-diag-$(DIMINUTO_PROJECT)/$(DIMINUTO_TITLE)
DIMINUTO_HEADERS	:=	$(DIMINUTO_ROOT)/$(INC_DIR)
DIMINUTO_LIBRARIES	:=	$(DIMINUTO_ROOT)/$(OUT)/$(LIB_DIR)

DIMINUTO_CPPFLAGS	:=	-iquote $(DIMINUTO_HEADERS)
DIMINUTO_LDFLAGS	:=	-L$(DIMINUTO_LIBRARIES) -l$(DIMINUTO_PROJECT) -lpthread -lrt -ldl

########## Commands and Option Flags

PROJECT_A			:=	lib$(PROJECT).a
PROJECT_SO			:=	lib$(PROJECT).$(SO)

CROSS_COMPILE		:=	$(TOOLCHAIN)

CC					:=	$(CROSS_COMPILE)gcc
AR					:=	$(CROSS_COMPILE)ar
RANLIB				:=	$(CROSS_COMPILE)ranlib
STRIP				:=	$(CROSS_COMPILE)strip

CDEFINES			:=

ARFLAGS				:=	crsv
CPPFLAGS			:=	$(CDEFINES) -iquote $(SRC_DIR) -iquote $(INC_DIR) -iquote $(OUT)/$(INC_DIR) $(DIMINUTO_CPPFLAGS) $(CPPARCH)
CFLAGS				:=	$(CARCH) -g
CPFLAGS				:=	-i
MVFLAGS				:=	-i
LDFLAGS				:=	$(LDARCH) -l$(PROJECT) $(LDLIBRARIES) $(DIMINUTO_LDFLAGS)
MOFLAGS				:=	$(MOARCH) -l$(PROJECT) $(LDLIBRARIES)
SOFLAGS				:=	$(SOARCH) $(LDLIBRARIES)

########## Build Artifacts

TARGETAPPLICATIONS	:=	$(addprefix $(OUT)/,$(basename $(wildcard $(APP_DIR)/*)))
TARGETALIASES		:=	$(addprefix $(OUT)/$(BIN_DIR)/,$(ALIASES))
TARGETBINARIES		:=	$(addprefix $(OUT)/,$(basename $(wildcard $(BIN_DIR)/*.c)))
TARGETFUNCTIONALS	:=	$(addprefix $(OUT)/,$(basename $(wildcard $(FUN_DIR)/*.c)))
TARGETFUNCTIONALS	+=	$(addprefix $(OUT)/,$(basename $(wildcard $(FUN_DIR)/*.sh)))
TARGETGENERATED		:=	$(addprefix $(OUT)/$(BIN_DIR)/,$(GENERATED)) $(addprefix $(OUT)/$(SYM_DIR)/,$(GENERATED))
TARGETOBJECTS		:=	$(addprefix $(OUT)/$(OBC_DIR)/,$(addsuffix .o,$(basename $(wildcard $(SRC_DIR)/*.c)))) $(addprefix $(OUT)/$(OBC_DIR)/$(SRC_DIR)/,$(addsuffix .o,$(basename $(PROVIDENCED))))
ARGETSCRIPTS		:=	$(addprefix $(OUT)/,$(basename $(wildcard $(BIN_DIR)/*.sh)))
TARGETSCRIPTS		+=	$(addprefix $(OUT)/,$(wildcard $(BIN_DIR)/*.awk))
TARGETSYNTHESIZED	:=	$(addprefix $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/,$(SYNTHESIZED))
TARGETUNITTESTS		:=	$(addprefix $(OUT)/,$(basename $(wildcard $(TST_DIR)/*.c)))
TARGETUNITTESTS		+=	$(addprefix $(OUT)/,$(basename $(wildcard $(TST_DIR)/*.sh)))

TARGETARCHIVE		:=	$(OUT)/$(ARC_DIR)/$(PROJECT_A)
TARGETSHARED		:=	$(OUT)/$(LIB_DIR)/$(PROJECT_SO).$(MAJOR).$(MINOR)
TARGETSHARED		+=	$(OUT)/$(LIB_DIR)/$(PROJECT_SO).$(MAJOR)
TARGETSHARED		+=	$(OUT)/$(LIB_DIR)/$(PROJECT_SO)

TARGETLIBRARIES		:=	$(TARGETARCHIVE) $(TARGETSHARED)
TARGETPROGRAMS		:=	$(TARGETAPPLICATIONS) $(TARGETBINARIES) $(TARGETALIASES) $(TARGETUNITTESTS) $(TARGETFUNCTIONALS) $(TARGETTEMPLATES) $(TARGETGENERATED) $(TARGETSCRIPTS)
TARGETALL			:=	$(TARGETLIBRARIES) $(TARGETPROGRAMS)

########## Main Entry Points

.PHONY:	all dist clean pristine clobber scratch prepare

all:	$(TARGETALL)

dist:	distribution

clean:
	rm -rf $(OUT)
	rm -rf *.gcda *.gcno *.gcov

pristine:	clean
	rm -rf $(OUT_DIR)

# This is not the same as simply listing the targets as dependencies.
scratch:
	make pristine
	make depend
	make all

clobber:	pristine
	rm -f .cscope.lst .cscope.out .cscope.out.in .cscope.out.po

prepare:
	mkdir -p $(CFG_DIR); touch $(CFG_DIR)/host.mk
	mkdir -p $(APP_DIR)/PLACEHOLDER; touch $(APP_DIR)/PLACEHOLDER/PLACEHOLDER.txt
	for D in $(BIN_DIR) $(CFG_DIR) $(DAT_DIR) $(ETC_DIR) $(EXT_DIR) $(OLY_DIR) $(FUN_DIR) $(INC_DIR) $(SRC_DIR) $(TST_DIR) $(TXT_DIR); do \
		mkdir -p $$D; touch $$D/PLACEHOLDER.txt; \
	done

########## Packaging and Distribution

# Useful for copying the executables over to another target for which they were
# cross compiled.

.PHONY:	package

package $(PACKAGE).tgz:
	D=`dirname $(PACKAGE)`; mkdir -p $$D; \
	for M in $(MANIFEST); do mkdir -p $(OUT)/$$M; done; \
	T=`mktemp -d "$(TEMP_DIR)/$(PROJECT).XXXXXXXXXX"`; \
	B=`basename $(PACKAGE)`; mkdir -p $$T/$$B; \
	tar -C $(OUT) --exclude-vcs -cvf - $(MANIFEST) | tar -C $$T/$$B -xvf -; \
	tar --exclude-vcs -cvf - $(INC_DIR) | tar -C $$T/$$B -xvf -; \
	tar -C $$T --exclude-vcs -cvzf - $$B > $(PACKAGE).tgz; \
	rm -rf $$T

# Useful for given someone a tarball of the actual source distribution that
# is guaranteed to at least build.

.PHONY:	distribution distro

distribution distro $(DISTRIBUTION).tgz:
	D=`dirname $(DISTRIBUTION)`; mkdir -p $$D; \
	T=`mktemp -d "$(TEMP_DIR)/$(PROJECT).XXXXXXXXXX"`; \
	B=`basename $(DISTRIBUTION)`; \
	( cd $$T; git clone $(GITURL) $$B ); \
	tar -C $$T --exclude-vcs -cvzf - ./$$B > $(DISTRIBUTION).tgz; \
	rm -rf $$T/$$B; \
	tar -C $$T -xvzf - < $(DISTRIBUTION).tgz; \
	( cd $$T/$$B/$(TITLE); make all TARGET=host OUT=out/host && $(OUT)/bin/generate > ./setup && . ./setup && vintage ); \
	rm -rf $$T

# Useful for copying a tarball of the current development source base to a
# target for which there is no cross compiler toolchain.

.PHONY:	tarball

tarball $(TARBALL).tgz:
	D=`dirname $(TARBALL)`; mkdir -p $$D; \
	T=`pwd`; \
	B=`basename $$T`; \
	( tar -C .. --exclude-vcs --exclude=$(OUT_DIR) --exclude=.??* -cvzf - $$B ) > $(TARBALL).tgz; \

# Useful for backing a complete backup before doing something that may turn
# out to be profoundly stupid, like running a transformative script across all
# the source files. Sure, your local and remote repos should save you, but what
# if they didn't?

.PHONY:	backup

backup:
	tar --exclude=$(OUT_DIR) -cvzf - . > $(HOME)/$(PROJECT)-$(shell date -u +%Y%m%d%H%M%S%N%Z).tgz

########## Target C Libraries

$(OUT)/$(ARC_DIR)/$(PROJECT_A):	$(TARGETOBJECTS)
	D=`dirname $@`; mkdir -p $$D
	$(AR) $(ARFLAGS) $@ $^
	$(RANLIB) $@

$(OUT)/$(LIB_DIR)/lib$(PROJECT).$(SO).$(MAJOR).$(MINOR):	$(TARGETOBJECTS)
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CPPFLAGS) $(CFLAGS) $(A2SOARCH) -o $@ $(SOFLAGS) $(TARGETOBJECTS)

$(OUT)/$(LIB_DIR)/lib$(PROJECT).$(SO).$(MAJOR):	$(OUT)/$(LIB_DIR)/lib$(PROJECT).$(SO).$(MAJOR).$(MINOR)
	D=`dirname $<`; F=`basename $<`; T=`basename $@`; ( cd $$D; ln -s -f $$F $$T ) 

$(OUT)/$(LIB_DIR)/lib$(PROJECT).$(SO):	$(OUT)/$(LIB_DIR)/lib$(PROJECT).$(SO).$(MAJOR)
	D=`dirname $<`; F=`basename $<`; T=`basename $@`; ( cd $$D; ln -s -f $$F $$T ) 

########## Target Unstripped Applications

$(OUT)/$(APP_DIR)/%:	$(APP_DIR)/% $(TARGETLIBRARIES)
	D=`dirname $@`; mkdir -p $$D
	test -r $</main.c && $(CC) -iquote $< $(CPPFLAGS) $(CFLAGS) -o $@ $</*.c $(LDFLAGS) || true

########## Target Unstripped Binaries

$(OUT)/$(SYM_DIR)/%:	$(OUT)/$(OBC_DIR)/$(BIN_DIR)/%.o $(TARGETLIBRARIES)
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

########## Target Aliases

$(OUT)/$(BIN_DIR)/hex $(OUT)/$(BIN_DIR)/oct $(OUT)/$(BIN_DIR)/ntohs $(OUT)/$(BIN_DIR)/htons $(OUT)/$(BIN_DIR)/ntohl $(OUT)/$(BIN_DIR)/htonl:	$(OUT)/$(BIN_DIR)/dec
	ln -f $< $@

########## Unit Tests

$(OUT)/$(TST_DIR)/%:	$(OUT)/$(OBC_DIR)/$(TST_DIR)/%.o $(TARGETLIBRARIES)
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

########## Functional Tests

$(OUT)/$(FUN_DIR)/%:	$(OUT)/$(OBC_DIR)/$(FUN_DIR)/%.o $(TARGETLIBRARIES)
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(OUT)/$(FUN_DIR)/%:	$(OUT)/$(OBX_DIR)/$(FUN_DIR)/%.o $(TARGETLIBRARIESXX) $(TARGETLIBRARIES)
	D=`dirname $@`; mkdir -p $$D
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDXXFLAGS)

########## Generated Source Files

SLASHES=2

ifeq ($(SLASHES), 1)

$(OUT)/$(GEN_DIR)/vintage.c:	Makefile $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_release.h $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_revision.h $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_vintage.h
	D=`dirname $@`; mkdir -p $$D
	@echo MAKE_VERSION=$(MAKE_VERSION) SLASHES=$(SLASHES)
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_release.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_release.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_vintage.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_vintage.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_revision.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_revision.h"' >> $@
	echo '#include <stdio.h>' >> $@
	echo '#include <assert.h>' >> $@
	echo 'static const char METADATA[] =' >> $@
	echo '    "Arch=\"$(ARCH)\"\n"' >> $@
	echo '    "Branch=\"$(BRANCH)\"\n"' >> $@
	echo '    "Contact=\"$(CONTACT)\"\n"' >> $@
	echo '    "Copyright=\"$(COPYRIGHT)\"\n"' >> $@
	echo '    "Homepage=\"$(HOMEPAGE)\"\n"' >> $@
	echo '    "Repository=\"$(GITURL)\"\n"' >> $@
	echo '    "Host=\"$(HOST)\"\n"' >> $@
	echo '    "Kernel=\"$(KERNEL_REV)\"\n"' >> $@
	echo '    "License=\"$(LICENSE)\"\n"' >> $@
	echo '    "Modified=\"$(MODIFIED)\"\n"' >> $@
	echo '    "Os=\"$(OS)\"\n"' >> $@
	echo '    "Release=\"" COM_DIAG_$(SYMBOL)_RELEASE "\"\n"' >> $@
	echo '    "Revision=\"" COM_DIAG_$(SYMBOL)_REVISION "\"\n"' >> $@
	echo '    "Root=\"$(ROOT)\"\n"' >> $@
	echo '    "Target=\"$(TARGET)\"\n"' >> $@
	echo '    "Title=\"$(TITLE)\"\n"' >> $@
	echo '    "Toolchain=\"$(TOOLCHAIN)\"\n"' >> $@
	echo '    "User=\"$(USER)\"\n"' >> $@
	echo '    "Vintage=\"" COM_DIAG_$(SYMBOL)_VINTAGE "\"\n"' >> $@
	echo ';' >> $@
	echo 'extern const char COM_DIAG_$(SYMBOL)_RELEASE_KEYWORD[];' >> $@
	echo 'extern const char * COM_DIAG_$(SYMBOL)_RELEASE_VALUE;' >> $@
	echo 'extern const char COM_DIAG_$(SYMBOL)_VINTAGE_KEYWORD[];' >> $@
	echo 'extern const char * COM_DIAG_$(SYMBOL)_VINTAGE_VALUE;' >> $@
	echo 'extern const char COM_DIAG_$(SYMBOL)_REVISION_KEYWORD[];' >> $@
	echo 'extern const char * COM_DIAG_$(SYMBOL)_REVISION_VALUE;' >> $@
	echo 'int main(void) {' >> $@
	echo '    const char * release_keyword = (const char *)0;' >> $@
	echo '    const char * release_value = (const char *)0;' >> $@
	echo '    const char * vintage_keyword = (const char *)0;' >> $@
	echo '    const char * vintage_value = (const char *)0;' >> $@
	echo '    const char * revision_keyword = (const char *)0;' >> $@
	echo '    const char * revision_value = (const char *)0;' >> $@
	echo '    fputs(METADATA, stdout);' >> $@
	echo '    fputs("$(MAJOR).$(MINOR).$(BUILD)\n", stderr);' >> $@
	echo '    release_keyword = COM_DIAG_$(SYMBOL)_RELEASE_KEYWORD;' >> $@
	echo '    release_value = COM_DIAG_$(SYMBOL)_RELEASE_VALUE;' >> $@
	echo '    vintage_keyword = COM_DIAG_$(SYMBOL)_VINTAGE_KEYWORD;' >> $@
	echo '    vintage_value = COM_DIAG_$(SYMBOL)_VINTAGE_VALUE;' >> $@
	echo '    revision_keyword = COM_DIAG_$(SYMBOL)_REVISION_KEYWORD;' >> $@
	echo '    revision_value = COM_DIAG_$(SYMBOL)_REVISION_VALUE;' >> $@
	echo '    assert(release_keyword != (const char *)0);' >> $@
	echo '    assert(release_value != (const char *)0);' >> $@
	echo '    assert(vintage_keyword != (const char *)0);' >> $@
	echo '    assert(vintage_value != (const char *)0);' >> $@
	echo '    assert(release_keyword != (const char *)0);' >> $@
	echo '    assert(release_value != (const char *)0);' >> $@
	echo '    return 0;' >> $@
	echo '}' >> $@

endif

ifeq ($(SLASHES), 2)

$(OUT)/$(GEN_DIR)/vintage.c:	Makefile $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_release.h $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_revision.h $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_vintage.h
	D=`dirname $@`; mkdir -p $$D
	@echo MAKE_VERSION=$(MAKE_VERSION) SLASHES=$(SLASHES)
	D=`dirname $@`; mkdir -p $$D
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_release.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_release.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_vintage.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_vintage.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_revision.h"' >> $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_revision.h"' >> $@
	echo '#include <stdio.h>' >> $@
	echo '#include <assert.h>' >> $@
	echo 'static const char METADATA[] =' >> $@
	echo '    "Arch=\\"$(ARCH)\\"\\n"' >> $@
	echo '    "Branch=\\"$(BRANCH)\\"\\n"' >> $@
	echo '    "Contact=\\"$(CONTACT)\\"\\n"' >> $@
	echo '    "Copyright=\\"$(COPYRIGHT)\\"\\n"' >> $@
	echo '    "Homepage=\\"$(HOMEPAGE)\\"\\n"' >> $@
	echo '    "Repository=\\"$(GITURL)\\"\\n"' >> $@
	echo '    "Host=\\"$(HOST)\\"\\n"' >> $@
	echo '    "Kernel=\\"$(KERNEL_REV)\\"\\n"' >> $@
	echo '    "License=\\"$(LICENSE)\\"\\n"' >> $@
	echo '    "Modified=\\"$(MODIFIED)\\"\\n"' >> $@
	echo '    "Os=\\"$(OS)\\"\\n"' >> $@
	echo '    "Release=\\"" COM_DIAG_$(SYMBOL)_RELEASE "\\"\\n"' >> $@
	echo '    "Revision=\\"" COM_DIAG_$(SYMBOL)_REVISION "\\"\\n"' >> $@
	echo '    "Root=\\"$(ROOT)\\"\\n"' >> $@
	echo '    "Target=\\"$(TARGET)\\"\\n"' >> $@
	echo '    "Title=\\"$(TITLE)\\"\\n"' >> $@
	echo '    "Toolchain=\\"$(TOOLCHAIN)\\"\\n"' >> $@
	echo '    "User=\\"$(USER)\\"\\n"' >> $@
	echo '    "Vintage=\\"" COM_DIAG_$(SYMBOL)_VINTAGE "\\"\\n"' >> $@
	echo ';' >> $@
	echo 'extern const char COM_DIAG_$(SYMBOL)_RELEASE_KEYWORD[];' >> $@
	echo 'extern const char * COM_DIAG_$(SYMBOL)_RELEASE_VALUE;' >> $@
	echo 'extern const char COM_DIAG_$(SYMBOL)_VINTAGE_KEYWORD[];' >> $@
	echo 'extern const char * COM_DIAG_$(SYMBOL)_VINTAGE_VALUE;' >> $@
	echo 'extern const char COM_DIAG_$(SYMBOL)_REVISION_KEYWORD[];' >> $@
	echo 'extern const char * COM_DIAG_$(SYMBOL)_REVISION_VALUE;' >> $@
	echo 'int main(void) {' >> $@
	echo '    const char * release_keyword = (const char *)0;' >> $@
	echo '    const char * release_value = (const char *)0;' >> $@
	echo '    const char * vintage_keyword = (const char *)0;' >> $@
	echo '    const char * vintage_value = (const char *)0;' >> $@
	echo '    const char * revision_keyword = (const char *)0;' >> $@
	echo '    const char * revision_value = (const char *)0;' >> $@
	echo '    fputs(METADATA, stdout);' >> $@
	echo '    fputs("$(MAJOR).$(MINOR).$(BUILD)\\n", stderr);' >> $@
	echo '    release_keyword = COM_DIAG_$(SYMBOL)_RELEASE_KEYWORD;' >> $@
	echo '    release_value = COM_DIAG_$(SYMBOL)_RELEASE_VALUE;' >> $@
	echo '    vintage_keyword = COM_DIAG_$(SYMBOL)_VINTAGE_KEYWORD;' >> $@
	echo '    vintage_value = COM_DIAG_$(SYMBOL)_VINTAGE_VALUE;' >> $@
	echo '    revision_keyword = COM_DIAG_$(SYMBOL)_REVISION_KEYWORD;' >> $@
	echo '    revision_value = COM_DIAG_$(SYMBOL)_REVISION_VALUE;' >> $@
	echo '    assert(release_keyword != (const char *)0);' >> $@
	echo '    assert(release_value != (const char *)0);' >> $@
	echo '    assert(vintage_keyword != (const char *)0);' >> $@
	echo '    assert(vintage_value != (const char *)0);' >> $@
	echo '    assert(revision_keyword != (const char *)0);' >> $@
	echo '    assert(revision_value != (const char *)0);' >> $@
	echo '    return 0;' >> $@
	echo '}' >> $@

endif

$(OUT)/$(OBC_DIR)/$(SRC_DIR)/$(PROJECT)_release.o:	$(OUT)/$(SRC_DIR)/$(PROJECT)_release.c
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

$(OUT)/$(SRC_DIR)/$(PROJECT)_release.c:	Makefile $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_release.h
	D=`dirname $@`; mkdir -p $$D
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_release.h"' >> $@
	echo 'const char COM_DIAG_$(SYMBOL)_RELEASE_KEYWORD[] = "COM_DIAG_$(SYMBOL)_RELEASE=" COM_DIAG_$(SYMBOL)_RELEASE;' >> $@
	echo 'const char * COM_DIAG_$(SYMBOL)_RELEASE_VALUE = &COM_DIAG_$(SYMBOL)_RELEASE_KEYWORD[sizeof("COM_DIAG_$(SYMBOL)_RELEASE=") - 1];' >> $@

$(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_release.h:	Makefile
	D=`dirname $@`; mkdir -p $$D
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#ifndef _H_COM_DIAG_$(SYMBOL)_RELEASE_' >> $@
	echo '#define _H_COM_DIAG_$(SYMBOL)_RELEASE_' >> $@
	echo '#define COM_DIAG_$(SYMBOL)_RELEASE_MAJOR $(MAJOR)' >> $@
	echo '#define COM_DIAG_$(SYMBOL)_RELEASE_MINOR $(MINOR)' >> $@
	echo '#define COM_DIAG_$(SYMBOL)_RELEASE_BUILD $(BUILD)' >> $@
	echo '#define COM_DIAG_$(SYMBOL)_RELEASE "$(MAJOR).$(MINOR).$(BUILD)"' >> $@
	echo '#endif' >> $@

$(OUT)/$(OBC_DIR)/$(SRC_DIR)/$(PROJECT)_revision.o:	$(OUT)/$(SRC_DIR)/$(PROJECT)_revision.c
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

$(OUT)/$(SRC_DIR)/$(PROJECT)_revision.c:	Makefile $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_revision.h
	D=`dirname $@`; mkdir -p $$D
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_revision.h"' >> $@
	echo 'const char COM_DIAG_$(SYMBOL)_REVISION_KEYWORD[] = "COM_DIAG_$(SYMBOL)_REVISION=" COM_DIAG_$(SYMBOL)_REVISION;' >> $@
	echo 'const char * COM_DIAG_$(SYMBOL)_REVISION_VALUE = &COM_DIAG_$(SYMBOL)_REVISION_KEYWORD[sizeof("COM_DIAG_$(SYMBOL)_REVISION=") - 1];' >> $@

$(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_revision.h:	Makefile
	D=`dirname $@`; mkdir -p $$D
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#ifndef _H_COM_DIAG_$(SYMBOL)_REVISION_' >> $@
	echo '#define _H_COM_DIAG_$(SYMBOL)_REVISION_' >> $@
	echo '#define COM_DIAG_$(SYMBOL)_REVISION "$(REVISION)"' >> $@
	echo '#endif' >> $@

$(OUT)/$(OBC_DIR)/$(SRC_DIR)/$(PROJECT)_vintage.o:	$(OUT)/$(SRC_DIR)/$(PROJECT)_vintage.c
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

$(OUT)/$(SRC_DIR)/$(PROJECT)_vintage.c:	Makefile $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_vintage.h
	D=`dirname $@`; mkdir -p $$D
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#include "com/diag/$(PROJECT)/$(PROJECT)_vintage.h"' >> $@
	echo 'const char COM_DIAG_$(SYMBOL)_VINTAGE_KEYWORD[] = "COM_DIAG_$(SYMBOL)_VINTAGE=" COM_DIAG_$(SYMBOL)_VINTAGE;' >> $@
	echo 'const char * COM_DIAG_$(SYMBOL)_VINTAGE_VALUE = &COM_DIAG_$(SYMBOL)_VINTAGE_KEYWORD[sizeof("COM_DIAG_$(SYMBOL)_VINTAGE=") - 1];' >> $@

$(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_vintage.h:	Makefile
	D=`dirname $@`; mkdir -p $$D
	echo '/* GENERATED FILE! DO NOT EDIT! */' > $@
	echo '#ifndef _H_COM_DIAG_$(SYMBOL)_VINTAGE_' >> $@
	echo '#define _H_COM_DIAG_$(SYMBOL)_VINTAGE_' >> $@
	echo '#define COM_DIAG_$(SYMBOL)_VINTAGE "$(VINTAGE)"' >> $@
	echo '#endif' >> $@

$(OUT)/$(SYM_DIR)/vintage:	$(OUT)/$(GEN_DIR)/vintage.c $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_release.h $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_vintage.h $(OUT)/$(INC_DIR)/com/diag/$(PROJECT)/$(PROJECT)_revision.h
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(OUT)/$(BIN_DIR)/generate:	Makefile
	D=`dirname $@`; mkdir -p $$D
	echo 'COM_DIAG_$(SYMBOL)_PATH=`dirname $$0`; COM_DIAG_$(SYMBOL)_ROOT=`cd $$COM_DIAG_$(SYMBOL)_PATH; pwd`' > $@
	echo 'echo export PATH=\\$$PATH:$$COM_DIAG_$(SYMBOL)_ROOT/../$(APP_DIR):$$COM_DIAG_$(SYMBOL)_ROOT/../$(BIN_DIR):$$COM_DIAG_$(SYMBOL)_ROOT/../$(TST_DIR):$$COM_DIAG_$(SYMBOL)_ROOT/../$(FUN_DIR)' >> $@
	echo 'echo export LD_LIBRARY_PATH=\\$$LD_LIBRARY_PATH:$$COM_DIAG_$(SYMBOL)_ROOT/../$(LIB_DIR)' >> $@
	echo 'echo . $(DIMINUTO_ROOT)/$(OUT)/$(BIN_DIR)/setup' >> $@
	chmod $(MODE) $@

$(OUT)/$(SYM_DIR)/generate:	Makefile
	D=`dirname $@`; mkdir -p $$D
	echo 'COM_DIAG_$(SYMBOL)_PATH=`dirname $$0`; COM_DIAG_$(SYMBOL)_ROOT=`cd $$COM_DIAG_$(SYMBOL)_PATH; pwd`' > $@
	echo 'echo export PATH=\\$$PATH:$$COM_DIAG_$(SYMBOL)_ROOT/../$(APP_DIR):$$COM_DIAG_$(SYMBOL)_ROOT/../$(SYM_DIR):$$COM_DIAG_$(SYMBOL)_ROOT/../$(BIN_DIR):$$COM_DIAG_$(SYMBOL)_ROOT/../$(TST_DIR):$$COM_DIAG_$(SYMBOL)_ROOT/../$(FUN_DIR)' >> $@
	echo 'echo export LD_LIBRARY_PATH=\\$$LD_LIBRARY_PATH:$$COM_DIAG_$(SYMBOL)_ROOT/../$(LIB_DIR)' >> $@
	echo 'echo . $(DIMINUTO_ROOT)/$(OUT)/$(SYM_DIR)/setup' >> $@
	chmod $(MODE) $@

$(OUT)/$(BIN_DIR)/setup:	$(OUT)/$(BIN_DIR)/generate
	D=`dirname $@`; mkdir -p $$D
	$< > $@
	chmod 644 $@

$(OUT)/$(SYM_DIR)/setup:	$(OUT)/$(SYM_DIR)/generate
	D=`dirname $@`; mkdir -p $$D
	$< > $@
	chmod 644 $@

########## User-Space Loadable Modules

LDWHOLEARCHIVES := # These archives will be linked into the shared object in their entirety.

$(OUT)/$(MOD_DIR)/%.$(SO):	$(MOD_DIR)/%.c
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CPPFLAGS) $(CFLAGS) -shared -o $@ $< $(MOFLAGS) -Wl,--whole-archive $(LDWHOLEARCHIVES) -Wl,--no-whole-archive

########## Helpers

.PHONY:	makeversion gccversion implicit defines iquotes isystems out

makeversion:
	@echo $(MAKE_VERSION)

gccversion:
	@$(CC) -x c $(CPPFLAGS) $(CFLAGS) -E -v - < /dev/null

implicit:
	@$(CC) $(CFLAGS) -dM -E - < /dev/null
	
defines:
	@$(CC) $(CPPFLAGS) $(CFLAGS) -dM -E - < /dev/null

iquotes:
	@$(CC) -x c $(CPPFLAGS) $(CFLAGS) -E -v - < /dev/null 2>&1 | awk 'BEGIN { S=0; } ($$0=="#include \"...\" search starts here:") { S=1; next; } ($$0=="#include <...> search starts here:") { S=0; next; } (S!=0) { print $$1; } { next; }'

isystems:
	@$(CC) -x c $(CPPFLAGS) $(CFLAGS) -E -v - < /dev/null 2>&1 | awk 'BEGIN { S=0; } ($$0=="#include <...> search starts here:") { S=1; next; } ($$0=="End of search list.") { S=0; next; } (S!=0) { print $$1; } { next; }'

out:
	@echo $(OUT)

########## Documentation

# sudo apt-get install doxygen
# sudo apt-get install ghostscript
# sudo apt-get install latex
# sudo apt-get install texlive
# sudo apt-get install tabu
# sudo apt-get install texlive-latex-extra

.PHONY:	documentation manuals readme

DOCCOOKED := $(shell echo $(OUT)/$(DOC_DIR) | sed 's/\//\\\//g')

documentation $(OUT)/$(DOC_DIR)/latex $(OUT)/$(DOC_DIR)/man $(OUT)/$(DOC_DIR)/pdf:
	mkdir -p $(OUT)/$(DOC_DIR)/pdf
	cat doxygen.cf | \
		sed -e "s/\\\$$PROJECT_NUMBER\\\$$/$(MAJOR).$(MINOR).$(BUILD)/" | \
		sed -e "s/\\\$$OUTPUT_DIRECTORY\\\$$/$(DOCCOOKED)/" | \
		cat > $(OUT)/$(DOC_DIR)/doxygen-local.cf
	doxygen $(OUT)/$(DOC_DIR)/doxygen-local.cf

manuals:	$(OUT)/$(DOC_DIR)/latex $(OUT)/$(DOC_DIR)/man $(OUT)/$(DOC_DIR)/pdf
	mkdir -p $(OUT)/$(DOC_DIR)/pdf
	$(MAKE) -C $(OUT)/$(DOC_DIR)/latex refman.pdf || exit 0
	cp $(OUT)/$(DOC_DIR)/latex/refman.pdf $(OUT)/$(DOC_DIR)/pdf
	cat $(OUT)/$(DOC_DIR)/man/man3/*.3 | groff -man -Tps - > $(OUT)/$(DOC_DIR)/pdf/manpages.ps
	ps2pdf $(OUT)/$(DOC_DIR)/pdf/manpages.ps $(OUT)/$(DOC_DIR)/pdf/manpages.pdf

$(OUT)/$(DOC_DIR)/html/README.html:	../README.md
	mkdir -p $(OUT)/$(DOC_DIR)/html
	grip ../README.md --export $(OUT)/$(DOC_DIR)/html/README.html

readme:	$(OUT)/$(DOC_DIR)/html/README.html

########## Diffs and Patches

.PHONY:	patch

patch:	$(OLD) $(NEW)
	diff -purN $(OLD) $(NEW)

########## Rules

$(OUT)/$(OBC_DIR)/%.txt:	%.c $(TARGETSYNTHESIZED)
	D=`dirname $@`; mkdir -p $$D
	$(CC) -E $(CPPFLAGS) -c $< > $@

$(OUT)/$(OBC_DIR)/%.o:	%.c $(TARGETSYNTHESIZED)
	D=`dirname $@`; mkdir -p $$D
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

$(OUT)/%:	%.sh
	D=`dirname $@`; mkdir -p $$D
	cp $< $@
	chmod $(MODE) $@

$(OUT)/%.awk:	%.awk
	D=`dirname $@`; mkdir -p $$D
	cp $< $@
	chmod $(MODE) $@

.SECONDARY:

$(OUT)/$(BIN_DIR)/%:	$(OUT)/$(SYM_DIR)/%
	D=`dirname $@`; mkdir -p $$D
	$(STRIP) -o $@ $<

########## Dependencies

.PHONY:	depend

DEPENDENCIES := $(OUT)/$(DEP_DIR)/dependencies.mk

depend:	$(TARGETSYNTHESIZED)
	M=`dirname $(DEPENDENCIES)`; mkdir -p $$M
	cp /dev/null $(DEPENDENCIES)
	for S in $(APP_DIR)/* $(BIN_DIR) $(MOD_DIR) $(SRC_DIR) $(TST_DIR) $(FUN_DIR); do \
		if [ -d $$S ]; then \
			for F in $$S/*.c; do \
				D=`dirname $$F`; \
				T=`mktemp "$(TEMP_DIR)/$(PROJECT).XXXXXXXXXX"`; \
				echo -n "$(OUT)/$(OBC_DIR)/$$D/" > $$T; \
				$(CC) $(CPPFLAGS) -MM -MG $$F >> $$T && cat $$T >> $(DEPENDENCIES); \
				rm -f $$T; \
			done; \
		fi; \
	done

-include $(DEPENDENCIES)

########## Installation

.PHONY:	install install-bin install-lib install-include

INSTALL_DIR := /usr/local
INSTALL_BIN := $(INSTALL_DIR)/bin
INSTALL_LIB := $(INSTALL_DIR)/lib
INSTALL_INC := $(INSTALL_DIR)/include

install:	install-bin install-lib install-include

install-bin:
	mkdir -p $(INSTALL_BIN)
	for B in $(OUT)/$(BIN_DIR)/*; do \
		install $$B $(INSTALL_BIN); \
	done

install-lib:
	mkdir -p $(INSTALL_LIB)
	for F in $(OUT)/$(LIB_DIR)/*.so; do \
		O=`basename $$F`; \
		cp $(OUT)/$(LIB_DIR)/$$O.$(MAJOR).$(MINOR) $(INSTALL_LIB); \
		( cd $(INSTALL_LIB); ln -s -f $$O.$(MAJOR).$(MINOR) $$O.$(MAJOR) ); \
		( cd $(INSTALL_LIB); ln -s -f $$O.$(MAJOR) $$O ); \
	done
	ldconfig -v $(INSTALL_LIB)

install-include:
	mkdir -p $(INSTALL_INC)
	tar -C $(OUT)/$(INC_DIR) -cvf - . | tar -C $(INSTALL_INC) -xvf -
	tar -C $(INC_DIR) -cvf - . | tar -C $(INSTALL_INC) -xvf -

########## Unit Test

.PHONY: sanity

sanity:
	R="PASSED."; \
	mkdir -p $(OUT)/log; \
	cp /dev/null $(OUT)/log/unit-test.log; \
	for U in $(TARGETUNITTESTS); do \
		echo "UNIT TEST" $$U >> $(OUT)/log/unit-test.log; \
		T="PASSED."; \
		$$U >> $(OUT)/log/unit-test.log 2>&1 || T="FAILED!"; \
		echo "UNIT TEST" $$U: $$T; \
		test "$$T" = "FAILED!" && R="$$T"; \
	done; \
	echo $$R 1>&2
