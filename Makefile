# Dynamic Makefile (written by Clay Freeman)
# License: http://creativecommons.org/licenses/by-sa/4.0/

#################################### CONFIG ####################################

# BASH holds the executable for bash.  This is needed for color output.
# CPPCHECK holds the executable to check your source files.
# You can change CXX to clang if you wish, or edit the compiler flags CXXFLAGS.
# VALGRIND holds the executable to test memory leaks.
# ZIP holds the executable to make ZIPs.  Edit ZIPFLAGS if -q causes problems.
BASH		:= bash
BASHFLAGS	:= -c
CPPCHECK	:= cppcheck
CPPCHECKFLAGS	:= --enable=warning,style,performance,portability --std=posix
CXX		:= g++
CXXFLAGS	:= -g -std=c++11 -Wall -Wextra -pedantic -fPIC -DDEBUG=0
VALGRIND	:= valgrind
VALGRINDFLAGS	:= --tool=memcheck --leak-check=full --dsymutil=yes \
			--show-leak-kinds=all
ZIP		:= zip
ZIPFLAGS	:= -q

# Color codes for colored output.  These can be changed, but at your own risk.
ERROR		:= \x1b[31;01m
OK		:= \x1b[32;01m
RESET		:= \x1b[0m
WARN		:= \x1b[33;01m

################################### INTERNAL ###################################

# Don't touch these variables
LIBS		 = $(shell touch .Makefile-libs && cat .Makefile-libs)
MODSDIR		 = $(shell touch .Makefile-modsdir && cat .Makefile-modsdir)

ifneq ($(words $(shell touch .Makefile-out && cat .Makefile-out)),0)
OUT		 = $(shell cat .Makefile-out)
else
OUT		 = $(DIR)
endif

RWILDCARD	 = $(wildcard $(addsuffix $2, $1)) $(foreach d,$(wildcard \
			$(addsuffix *, $1)),$(call RWILDCARD,$d/,$2))
DEPENDCPP	:= $(subst ./,,$(call RWILDCARD,./,*.cpp))
DEPENDMODULES	:= $(subst ./,,$(call RWILDCARD,$(MODSDIR),*.cpp))
$(foreach item,$(DEPENDMODULES), \
	$(eval DEPENDCPP := $(filter-out $(item),$(DEPENDCPP))) \
)
DEPENDH		:= $(subst ./,,$(call RWILDCARD,./,*.h)) \
			$(subst ./,,$(call RWILDCARD,./,*.hpp))
DEPENDO		:= $(patsubst %.cpp,%.o, $(DEPENDCPP))
DEPENDSO	:= $(patsubst %.cpp,%.so, $(DEPENDMODULES))
DIR		:= $(shell basename "`pwd`")
CLEAN		:= $(subst ./,,$(call RWILDCARD,./,*.dSYM)) $(DEPENDO) \
			$(DEPENDSO) $(OUT) $(OUT).zip

  ############################### UTIL TARGETS ###############################

# Builds and links the application
target_default	 =

ifeq ($(words $(MAKECMDGOALS)),0)
target_default	 = yes
endif

ifeq ($(words $(MAKECMDGOALS)),1)
target_default	 = yes
endif

ifndef target_default

.NOTPARALLEL:

$(MAKECMDGOALS):%:
	@$(MAKE) --no-print-directory $@
	@exit 0

endif

ifdef target_default

all:		$(OUT) $(DEPENDSO)

# Builds with macro DEBUG set to 1 instead of 0
debug:		.debug all
.debug:
	$(eval CXXFLAGS := $(filter-out -DDEBUG=%,$(CXXFLAGS)))
	$(eval CXXFLAGS := $(CXXFLAGS) -DDEBUG=1)

# Builds a ZIP file of your CPP/H/Makefile files
zip:		$(OUT).zip

# Output number of lines in files that match '(\.c(pp)?$)|(\.h(pp)?$)'
lines:
	@find . -type f | egrep '(\.c(pp)?$$)|(\.h(pp)?$$)' | sort | xargs wc -l

# Run cppcheck and valgrind to point out any potential mistakes in your code
test:		all
	@$(foreach item,$(DEPENDCPP), \
		$(BASH) $(BASHFLAGS) "printf \"[$(WARN)CHK$(RESET)] \""; \
		$(CPPCHECK) $(CPPCHECKFLAGS) $(item); \
	)
	@$(BASH) $(BASHFLAGS) \
		"echo -e \"[$(WARN)CHK$(RESET)] Press enter to run memcheck.\""
	@read cont
	@$(VALGRIND) $(VALGRINDFLAGS) ./$(OUT)

# Remove any compiled or ZIP files if they exist
clean:
	@$(foreach item,$(CLEAN), $(BASH) $(BASHFLAGS) \
		"if [ -a $(item) ]; then \
			echo -e \"[$(ERROR)DEL$(RESET)] $(item)\"; \
			rm -rf $(item); \
		fi;"; \
	)

endif

  ############################## BUILD TARGETS ###############################

# Links your application.  Depends on all applicable .o files
$(OUT):		$(DEPENDO)
	@$(BASH) $(BASHFLAGS) "echo -e \"[$(OK)LNK$(RESET)] $@ ...\""
	@$(CXX) $(CXXFLAGS) -rdynamic -o $@ $^ $(LIBS)

# Builds a ZIP file from your source files and Makefile
$(OUT).zip:	$(DEPENDCPP) $(DEPENDMODULES) $(DEPENDH) Makefile
	@rm -f $@
	@$(BASH) $(BASHFLAGS) "echo -e \"[$(OK)ZIP$(RESET)] $@ ...\""
	@$(ZIP) $(ZIPFLAGS) -r $@ $^

# Builds any object file from a CPP file
%.o:		%.cpp | $(DEPENDH)
	@$(BASH) $(BASHFLAGS) "echo -e \"[$(WARN)CXX$(RESET)] $@ ...\""
	@$(CXX) $(CXXFLAGS) -c -o $@ $^

%.so:		%.cpp | $(DEPENDH)
	@$(BASH) $(BASHFLAGS) "echo -e \"[$(WARN)CSO$(RESET)] $@ ...\""
ifneq ($(shell uname),Darwin)
	@$(CXX) $(CXXFLAGS) -shared -o $@ $^
else
	@$(CXX) $(CXXFLAGS) -dynamiclib -undefined suppress -flat_namespace \
		-o $@ $^
endif
