# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-tex-install-base-packages:
  pkg.installed:
    - pkgs:
      - build-essential
      - texlive-latex-extra
      - texlive-extra-utils # Texlive is needed for pdf manipulation (pdfnup & pdfjam). See functions/helpers
      - texlive-fonts-recommended
      - texlive-fonts-extra
      - texlive-bibtex-extra
      - biber

common-tex-add-texmf-d-custom-tex-config:
  file.managed:
    - name: '/etc/texmf/texmf.d/50s2e.cnf'
    - makedirs: True
    - replace: True
    - clean: True
    - contents: |
        % Tex Home Directory Structure https://tug.ctan.org/tds/tds.html
        TEXMFHOME=/home/user/.texmf


# Update the .tex files database
'mktexlsr':
  cmd.run
