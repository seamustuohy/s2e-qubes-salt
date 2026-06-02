HOST=$(shell hostname)
PACKAGE_NAME = "qubes-s2e-NAME"
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

.PHONY: prep-rpm-dev-vm
prep-rpm-dev-vm:
	rm -fr /tmp/rpm_package
	rm -fr /tmp/${PACKAGE_NAME}-${VERSION_NUM}
	cp -fr ../${PACKAGE_NAME} /tmp/${PACKAGE_NAME}-${VERSION_NUM}
	mkdir -p /tmp/rpm_package
	# Make a tarred folder with no higher folder path
	tar czf /tmp/rpm_package/${PACKAGE_NAME}-${VERSION_NUM}.tar.gz -C /tmp ${PACKAGE_NAME}-${VERSION_NUM}
	# Add the spec file in
	cp ${PACKAGE_NAME}.spec /tmp/rpm_package/${PACKAGE_NAME}.spec
	# Add this make file in
	cp Makefile /tmp/rpm_package/Makefile
	qvm-copy /tmp/rpm_package

.PHONY: rpmbuild-build-vm
rpmbuild-build-vm:
	rm -fr ~/rpmbuild
	rpmdev-setuptree
	cp ${PACKAGE_NAME}-${VERSION_NUM}.tar.gz ~/rpmbuild/SOURCES/.
	cp ${PACKAGE_NAME}.spec ~/rpmbuild/SPECS/.
	cd ~/rpmbuild && rpmlint SPECS/${PACKAGE_NAME}.spec
	read  -n 1 -p "If you don't see any errors press ANY key. If you do, press Ctrl-C to exit:" DONTUSE
	cd ~/rpmbuild && rpmbuild -ba SPECS/${PACKAGE_NAME}.spec

.PHONY: update-binaries clean-binaries
update-binaries: assert-not-dom0 clean-binaries # state/files/pubkey

clean-binaries:
	echo "FILL THIS WITH BINARY REMOVALS."
	# rm -f state/files/pubkey

#state/files/pubkey:
#	wget -NO "state/files/pubkey" "https://XXXXXXX.XXX/linux/download/pubkey"


.PHONY: state install
install: assert-not-dom0 state

state:
	mkdir -p ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${PACKAGE_NAME}.top ${DESTDIR}${SALT_PREFIX}
	cp -r ${SALT_STATE_PATH}files ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}clone.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
	cp ${SALT_STATE_PATH}install.sls ${DESTDIR}${SALT_PREFIX}/${PACKAGE_NAME}
