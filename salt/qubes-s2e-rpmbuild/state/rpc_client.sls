# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :


qubes-s2e-add-RpmBuild-Client:
  file.managed:
    - name: '/usr/bin/send-rpmbuild'
    - source: "salt://qubes-s2e-rpmbuild/files/send-rpmbuild.sh"
    - mode: 755
    - replace: True
    - clean: True
