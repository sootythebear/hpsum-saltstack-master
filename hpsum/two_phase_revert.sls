reset_hpsum_run:
  module.run:
    - name: grains.setval
    - key: hpsum_run
    - val: False

reset_twophase:
  module.run:
    - name: grains.setval
    - key: hpsum_twophase
    - val: ""
