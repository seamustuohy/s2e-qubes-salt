HOST=$(shell hostname)
PACKAGE_NAME = "qubes-s2e-common"
VERSION_NUM = "0.0.1"
SALT_PREFIX ?= /srv/user_salt/
PILLAR_PREFIX ?= /srv/user_pillar/
# The path of the state files
SALT_STATE_PATH = state/
# The path of the pillar files
SALT_PILLAR_PATH = pillar/

.PHONY: clean update-binaries install assert-not-dom0

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
update-binaries: assert-not-dom0 clean-binaries state/files/yt-dlp state/files/inkstitch.deb

clean-binaries:
	rm -f state/files/yt-dlp
	rm -f state/files/inkstitch.deb
# rm -f state/files/docker-key.gpg
# rm -f state/files/packages.mozilla.org.asc

state/files/yt-dlp:
	curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest \
		| jq -r '.tag_name' \
		| xargs -I % echo 'https://github.com/yt-dlp/yt-dlp/releases/download/%/yt-dlp' \
		| xargs -n 1 curl -L -o 'state/files/yt-dlp'

state/files/inkstitch.deb:
	curl -s https://api.github.com/repos/inkstitch/inkstitch/releases/latest \
		| jq -r '.id' \
		| xargs -I % curl -s 'https://api.github.com/repos/inkstitch/inkstitch/releases/%/assets' \
		| jq '.[] | select(select(.content_type == "application/x-debian-package") and select(.name | endswith("amd64.deb"))).browser_download_url' \
		| xargs -n 1 curl -L -o 'state/files/inkstitch.deb'


.PHONY: state install
install: assert-not-dom0 state

state:
	mkdir -p ${DESTDIR}${SALT_PREFIX}/common
	cp ${PACKAGE_NAME}.top ${DESTDIR}${SALT_PREFIX}/common.top
	cp ${SALT_STATE_PATH}/chromium.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/design.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/disk_trimming.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/docker-appvm.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/docker.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/emacs30.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/emacs.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/file-examine.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/file-management.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/file-view-and-mod.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/firefox.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/freecad.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/fstrim_cron.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/gnome-settings.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/libreoffice-appvm.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/net-utils.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/pip3.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/python3-base-max.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/python_linters.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/sys-utils.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/term-base.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/tex.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/timewarrior.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/tor.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/update_pkgs.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/warc-pip-libraries.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp ${SALT_STATE_PATH}/yt-dl.sls ${DESTDIR}${SALT_PREFIX}/common/
	cp -r ${SALT_STATE_PATH}files ${DESTDIR}${SALT_PREFIX}/common/
