# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

rpmbuild-helper-copy_file_install_rpmbuild_on_qube:
  file.managed:
    - name: '/usr/local/bin/qvm-install_rpmbuild_on_qube'
    - source: 'salt://qubes-s2e-rpmbuild/files/install_rpmbuild_on_qube.sh'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755

rpmbuild-helper-copy_file_display-next-dispvm-name:
  file.managed:
    - name: '/usr/local/bin/qvm-display-next-dispvm-name'
    - source: 'salt://qubes-s2e-rpmbuild/files/display-next-dispvm-name'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755

rpmbuild-helper-copy_file_copy-next-dispvm-rpm:
  file.managed:
    - name: '/usr/local/bin/qvm-copy-next-dispvm-rpm'
    - source: 'salt://qubes-s2e-rpmbuild/files/copy-next-dispvm-rpm'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755

rpmbuild-helper-copy-file-update-rpm-from-builder-script:
  file.managed:
    - name: '/usr/local/bin/qvm-update-rpm-from-builder'
    - source: 'salt://qubes-s2e-rpmbuild/files/update-rpm-from-builder'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755

rpmbuild-helper-copy-file-install-rpm-from-builder-script:
  file.managed:
    - name: '/usr/local/bin/qvm-install-rpm-from-builder'
    - source: 'salt://qubes-s2e-rpmbuild/files/install-rpm-from-builder'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755
