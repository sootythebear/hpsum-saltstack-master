{% from "hpsum/map.jinja" import hpsum with context %}

# Only proceed if we require to mount the filesystems
{% if hpsum.cust_nfs == 'False' %}

# If 'remote', mount the HP SUM folder
{% if hpsum.sum_type == 'rw' or hpsum.sum_type == 'ro' %}
mount_hpsum:
  mount.mounted:
    - name: {{ hpsum.nfs_sum_locallocation }}
    - device: {{ hpsum.sum_remotelocation }}
    - fstype: nfs
    - opts: {{ hpsum.sum_type }}
{% endif %}

# Always mount the baseline mount point
mount_baseline:
  mount.mounted:
    - name: {{ hpsum.baseline_localfs }}
    - device: {{ hpsum.baseline_remotefs }}
    - fstype: nfs
    - opts: 'ro'
{% endif %}
