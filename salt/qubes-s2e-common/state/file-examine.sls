# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-file-examine-binary-files:
  pkg.installed:
    - pkgs:
      - binutils # binary tools including the `strings` command

common-file-examine-file-metadata:
  pkg.installed:
    - pkgs:
      - libimage-exiftool-perl

common-file-examine-and-extract-information:
  pkg.installed:
    - pkgs:
      - urlview # Extract urls from a file
