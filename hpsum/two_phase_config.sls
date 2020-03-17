set_hpsum_run:
  module.run:
    - name: grains.setval
    - key: hpsum_run
    - val: True

set_twophase:
  module.run:
    - name: grains.setval
    - key: hpsum_twophase
    - val: HPSUM_drivers
