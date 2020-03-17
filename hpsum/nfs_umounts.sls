{% from "hpsum/map.jinja" import hpsum with context %}

# Only proceed if we were required to mount the filesystems
{% if hpsum.cust_nfs == 'False' %}

# If 'remote', unmount the HP SUM folder
{% if hpsum.sum_type == 'rw' or hpsum.sum_type == 'ro' %}
umount_hpsum:
  mount.unmounted:
    - name: {{ hpsum.nfs_sum_locallocation }}
{% endif %}

# Always unmount the baseline mount point
umount_baseline:
  mount.unmounted:
    - name: {{ hpsum.baseline_localfs }}
{% endif %}
