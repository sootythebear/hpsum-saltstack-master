{% from "hpsum/map.jinja" import hpsum with context %}

{% set finalselection = grains.get('hpsum_selection') %}
{% set sysid = grains.get('id') %}

{% if hpsum.report_only %}

# Run actual HP SUM command
run_hpsum_report_command:
  cmd.run:
    - name: {{ hpsum.actual_sum_location }}{{ hpsum.command_bin }} -s -logdir {{ hpsum.logdir }}{{ hpsum.date_time }} -use_location {{ hpsum.baseline_localfs }}{{ hpsum.iso_location }} {{ hpsum.report_type }} --reportdir {{ hpsum.report_dir }}/{{sysid}}
    - env:
      - TMPDIR: {{ hpsum.local_directory }}
    - cwd: {{ hpsum.actual_sum_location }}
    - timeout: 1740
    - onlyif: '/usr/bin/test -f {{ hpsum.actual_sum_location }}{{ hpsum.command_bin }}'

{% else %}
# Run actual HP SUM command
run_hpsum_command:
  cmd.run:
    - name: {{ hpsum.actual_sum_location }}{{ hpsum.command_bin }} -s -logdir {{ hpsum.logdir }}{{ hpsum.date_time }} -use_location {{ hpsum.baseline_localfs }}{{ hpsum.iso_location }} {{ hpsum.dryrun }} {{ finalselection }} {{ hpsum.reboot }} {{ hpsum.downgrade }} {{ hpsum.rewrite }} {{ hpsum.dependency }}
    - env:
      - TMPDIR: {{ hpsum.local_directory }}
    - cwd: {{ hpsum.actual_sum_location }}
    - timeout: 1740
    - onlyif: '/usr/bin/test -f {{ hpsum.actual_sum_location }}{{ hpsum.command_bin }}'

{% endif %}
