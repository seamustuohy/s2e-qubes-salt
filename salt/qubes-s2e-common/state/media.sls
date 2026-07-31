# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-media-video_update:
  pkg.uptodate:
    - refresh: True

common-media-install-video-tools:
  pkg.installed:
    - pkgs:
      - ffmpeg
