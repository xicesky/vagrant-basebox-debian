
# Skip implicit rules
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

include support/Make/*.mk

# Base configuration (no need to change that, really)
LOCAL_DIR           := local
CONFIG_DIR          := $(LOCAL_DIR)/config
BOX_OUTPUT_DIR      := $(LOCAL_DIR)

# What we are building
BOX_NAME            := sky-debian
BOX_VERSION         := 8.1.0
BOX_VAGRANT_NAME    := $(BOX_NAME)-$(BOX_VERSION)

# Where to "cache" the base boxes we build from
BOX_CACHE           := $(LOCAL_DIR)/box_cache

# Which base box to build from (TODO: Fetch this from the Vagrantfile)
BASEBOX             := bento/debian-8.5
BASEBOX_VERSION     := 2.2.9

# Derived values
BOX_OUTPUT          := $(BOX_OUTPUT_DIR)/$(BOX_VAGRANT_NAME).$(VAGRANT_DEFAULT_PROVIDER).box
BOX_DEPS            := $(shell find support/vagrant -type f)
BASEBOX_VNAME       := $(subst /,-VAGRANTSLASH-,$(BASEBOX))
BASEBOX_PATH        := $(VAGRANT_HOME)/boxes/$(BASEBOX_VNAME)/$(BASEBOX_VERSION)

# Phonys...
.PHONY: default box info clean
.PHONY:    basebox_add basebox_mutate
.PHONY: mutate upload

# and precious files.
.PRECIOUS: $(BOX_CACHE_DIR)/%

################################################################################

default: box

detailed_info: info
		@echo  "Vagrant home        : $(VAGRANT_HOME)"
		@echo  "Box ends up in      : $(BOX_OUTPUT_DIR)"
		@echo  "Boxes are cached in : $(BOX_CACHE)"
		@echo  "Base box            : $(BASEBOX)"
		@echo  "BB vagrant name     : $(BASEBOX_VNAME)"
		@echo  "-- Tools ----------------------------------------------------------------------"
		@echo  "Curl                : $(CURL)"
		@echo  "Vagrant             : $(VAGRANT)"

info:
		@echo  "Host system         : $(MY_OS)"
		@echo  "Machine name        : $(BOX_NAME)"
		@echo  "Machine file        : $(BOX_OUTPUT)"
		@echo  "Provider            : $(VAGRANT_DEFAULT_PROVIDER)"
#		@echo  "Dependencies        :"
#		@for i in $(BOX_DEPS) ; do echo "    $$i"; done

box: $(BOX_OUTPUT)

clean:
		-$(VAGRANT) destroy -f
		-rm -rf .vagrant

install: $(BOX_OUTPUT)
		$(VAGRANT) box add --name $(BOX_VAGRANT_NAME) $(BOX_OUTPUT)

uninstall:
		$(VAGRANT) box remove $(BOX_VAGRANT_NAME)

################################################################################
# How to actually build a new box

# This one only works with virtualbox
ifeq ($(VAGRANT_DEFAULT_PROVIDER),virtualbox)
$(BOX_OUTPUT_DIR)/$(BOX_VAGRANT_NAME).virtualbox.box: Vagrantfile $(BOX_DEPS) $(BASEBOX_PATH)/virtualbox
		$(VAGRANT) destroy -f
		$(VAGRANT) up
		$(VAGRANT) halt # Automatically happens on package anyway
		# Vagrant helps us with the package command here
		$(VAGRANT) package --output $@
		#$(VAGRANT) destroy -f
endif

# And this only works with libvirt
ifeq ($(VAGRANT_DEFAULT_PROVIDER),libvirt)
$(BOX_OUTPUT_DIR)/$(BOX_VAGRANT_NAME).libvirt.box: Vagrantfile $(BOX_DEPS) $(BASEBOX_PATH)/virtualbox
		$(VAGRANT) destroy -f
		$(VAGRANT) up
		$(VAGRANT) halt
		# Where is the qemu image now? -> lookup via virsh
		# for this we need the machine name or id, which we don't have...
		# For now, the machine name gets hardcoded in the Vagrantfile and in $(LIBVIRT_MACHINE_NAME)
		IMG=./find_machine_image.sh $(LIBVIRT_MACHINE_NAME) \
		@echo "Image: $$IMG"
		#$(VAGRANT) destroy -f
endif

################################################################################
# Basebox handling: Install baseboxes to vagrant automatically

$(BOX_CACHE):
		mkdir -p $@

$(VAGRANT_HOME)/boxes/%/0/virtualbox: $(BOX_CACHE)/%.virtualbox.box
		$(VAGRANT) box add --name $* $<

$(VAGRANT_HOME)/boxes/%/0/libvirt: $(BOX_CACHE)/%.libvirt.box
		$(VAGRANT) box add --name $* $<

$(VAGRANT_HOME)/boxes/%/0/libvirt: $(VAGRANT_HOME)/boxes/%/0/virtualbox
		$(VAGRANT) mutate --input_provider=virtualbox $* libvirt

#basebox_add: $(BOX_CACHE)/$(BASEBOX_VNAME).$(VAGRANT_DEFAULT_PROVIDER).box
#		$(VAGRANT) box add --name $(BASEBOX) $(BASEBOX_PATH)

#basebox_mutate: $(BOX_BASE_PATH)
#		$(VAGRANT) mutate $(BOX_BASE_PATH) $(VAGRANT_DEFAULT_PROVIDER)

# We can try to add boxes with defined versions using "vagrant box add"
$(VAGRANT_HOME)/boxes/$(BASEBOX_VNAME)/$(BASEBOX_VERSION)/%:
		$(VAGRANT) box add $(BASEBOX) --provider $* --box-version $(BASEBOX_VERSION)

################################################################################
# Hardcoded downloads

# https://github.com/kraksoft/vagrant-box-debian/releases
$(BOX_CACHE)/debian-7.8.0-amd64.virtualbox.box: | $(BOX_CACHE)
		$(CURL) -L "https://github.com/kraksoft/vagrant-box-debian/releases/download/7.8.0/debian-7.8.0-amd64.box" -o $@
