
# OS detection
OSNAME := $(shell uname -s)
ifeq ($(OS),Windows_NT)
	MY_OS := winnt
    ifneq (,$(findstring CYGWIN,$(OSNAME)))
        # Detected cygwin
        MY_OS := cygwin
    endif
    ifneq (,$(findstring MINGW,$(OSNAME)))
        # Detected mingw / msys
        MY_OS := msys
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
ifeq ($(MY_OS),msys)
	REAL_HOME := $(shell cygpath -u "$(USERPROFILE)")
endif

export OSNAME
export MY_OS
export REAL_HOME
