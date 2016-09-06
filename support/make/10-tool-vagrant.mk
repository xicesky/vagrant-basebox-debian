
# Find vagrant and some relevant paths

# Defaults
VAGRANT := $(shell which vagrant)
VAGRANT_HOME := $(REAL_HOME)/.vagrant.d
VAGRANT_DEFAULT_PROVIDER := virtualbox

# On linux, libvirt is the default provider
ifeq ($(MY_OS),linux)
    VAGRANT_DEFAULT_PROVIDER := libvirt
endif

# Vagrant default provider can be overriden in the config
ifneq (,$(wildcard $(CONFIG_DIR)/VAGRANT_PROVIDER))
    VAGRANT_DEFAULT_PROVIDER := $(shell cat local/config/VAGRANT_PROVIDER)
endif

export VAGRANT
export VAGRANT_DEFAULT_PROVIDER
export VAGRANT_HOME

#$(info VAGRANT: $(VAGRANT))
#$(info VAGRANT_DEFAULT_PROVIDER: $(VAGRANT_DEFAULT_PROVIDER))
#$(info VAGRANT_HOME: $(VAGRANT_HOME))
