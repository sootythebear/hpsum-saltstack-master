{% from "hpsum/map.jinja" import hpsum with context %}

{% if hpsum.local_clean %}
cleanup_local_dir:
  file.absent:
    - name: {{ hpsum.local_directory }}/localhpsum
{% endif %}
