{% from "hpsum/map.jinja" import hpsum_settings with context %}

include:
  - hpsum.clean_local
  - hpsum.dir_create
  - hpsum.nfs_mounts
  - hpsum.performcmd
  - hpsum.nfs_umounts
