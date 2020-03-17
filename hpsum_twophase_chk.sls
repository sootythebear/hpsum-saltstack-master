invoke_hpsum_two_phase:
  local.state.sls:
    - tgt: {{ data['id'] }}
    - arg:
      - hpsum.two_phase
