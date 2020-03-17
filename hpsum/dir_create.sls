{% from "hpsum/map.jinja" import hpsum with context %}

{% set sysid = grains.get('id') %}

{% if hpsum.cust_nfs == 'False' %}

{% if hpsum.sum_type == 'rw' or hpsum.sum_type == 'ro' %}
create_hpsum_mount_directory:
  file.directory:
    - name: {{ hpsum.nfs_sum_locallocation }}
    - user: root
    - group: root
    - dir_mode: 750
{% endif %}

create_baseline_mount_directory:
  file.directory:
    - name: {{ hpsum.baseline_localfs }}
    - user: root
    - group: root
    - dir_mode: 750

{% endif %}

{% if hpsum.report_only %}
create_indiv_report_directory:
  file.directory:
    - name: {{ hpsum.report_dir }}/{{ sysid }}
    - user: root
    - group: root
    - makedirs: True
    - dir_mode: 750
{% endif %}

create_logdir_directory:
  file.directory:
    - name: {{ hpsum.logdir }}
    - user: root
    - group: root
    - dir_mode: 750
