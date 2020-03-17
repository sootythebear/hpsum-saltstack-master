{% if grains.get('hpsum_run') %}

{% if grains.get('hpsum_twophase') == 'HPSUM_drivers' %}

set_driver_run:
  module.run:
    - name: grains.setval
    - key: hpsum_selection
    - val: '--romonly'

firstphase_done:
  module.run:
    - name: grains.setval
    - key: hpsum_twophase
    - val: HPSUM_firmware

{% elif grains.get('hpsum_twophase') == 'HPSUM_firmware' %}

set_firmware_run:
  module.run:
    - name: grains.setval
    - key: hpsum_selection
    - val: '--softwareonly'

secondphase_done:
  module.run:
    - name: grains.setval
    - key: hpsum_twophase
    - val: HPSUM_done

reset_hpsum_run:
  module.run:
    - name: grains.setval
    - key: hpsum_run
    - val: False
    
{% else %}

set_everything:
  module.run:
    - name: grains.setval
    - key: hpsum_selection
    - val: ''

{% endif %}

run_everything:
  module.run:
    - name: state.sls
    - mods: hpsum

{% endif %}
