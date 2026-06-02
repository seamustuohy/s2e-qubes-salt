# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-file-view-and-mod-structured-text-files:
  pkg.installed:
    - pkgs:
      - libxml2-utils # This package provides xmllint, a tool for validating and reformatting  XML documents, and xmlcatalog, a tool to parse and manipulate XML or  SGML catalog files.
      - jq # Command-line JSON processor

common-file-view-and-mod-unstructured-text-files:
  pkg.installed:
    - pkgs:
      - pandoc

common-file-view-and-mod-media-files:
  pkg.installed:
    - pkgs:
      - texlive-extra-utils # Texlive is needed for pdf manipulation (pdfnup & pdfjam). See functions/helpers
      - imagemagick # creation, modification and display of bitmap (convert & identify commands)
      - pdftk-java # Modify pdfs
      - qrencode # Create QR Codes

common-file-view-and-mod-html-files:
  pkg.installed:
    - pkgs:
      - lynx
