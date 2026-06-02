HOST=$(shell hostname)
PACKAGE_NAME = "qubes-s2e-neomutt"
VERSION_NUM = "0.0.1"
SALT_PREFIX ?= /srv/user_salt/
PILLAR_PREFIX ?= /srv/user_pillar/
# The path of the state files
SALT_STATE_PATH = state/
# The path of the pillar files
SALT_PILLAR_PATH = pillar/

.PHONY: assert-not-dom0

assert-not-dom0:
ifeq ($(HOST),"dom0")
	@echo "     ------ makefile should be run on the VM used to build the package. ------"
	@echo "     ------                  DO NOT run on dom0!                        ------"
	exit 1
endif

.PHONY: state install

install: assert-not-dom0 state

state:
	mkdir -p ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${PACKAGE_NAME}.top ${DESTDIR}${SALT_PREFIX}
	cp ${SALT_STATE_PATH}clone.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}install.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}configure.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}rpc.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}mailvm_scripts.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}cron_cold_storage.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}cron_appvm.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp -r ${SALT_STATE_PATH}files ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
