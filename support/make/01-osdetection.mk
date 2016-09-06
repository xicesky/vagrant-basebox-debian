
# OS detection
OSNAME := $(shell uname -s)
ifeq ($(OS),Windows_NT)
    ifneq (,$(findstring CYGWIN,$(OSNAME)))
        # Detected cygwin
        MY_OS := cygwin
    else
        MY_OS := winnt
    endif
else
    MY_OS := linux
endif
#$(info OS: $(OS))
#$(info OSNAME: $(OSNAME))
#$(info Detected OS: $(MY_OS))

REAL_HOME := $(HOME)
ifeq ($(MY_OS),cygwin)
	REAL_HOME := $(shell cygpath -u "$(USERPROFILE)")
endif

export OSNAME
export MY_OS
export REAL_HOME
