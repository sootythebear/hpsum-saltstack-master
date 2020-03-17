# hpsum-saltstack (Linux Local - Online)
========================================

About
-----
This state was designed to automate the process of performing (deploying) HP SUM Firmware and Software updates to multiple servers at the same time from a common respository. Note: the pre-work of sourcing and analysing HP SUM and the firmware/drivers, still needs to occur.

  * Linux manifests:
      * Proliant servers - Utilising NFS, the manifests can mount (if required) the HP SUM and/or Baseline respositories and either run HP SUM over NFS, or locally on the server.

How it works
------------
In this solution, SaltStack does not manage the Firmware/Software driver versioning, this is performed by the existing logic within the `HP SUM` software. 

In general, this `state` utilises the ability of `HP SUM` to be run over `NFS`. There are some pre-steps to setup NFS, HP SUM and cut the required baseline repositories for the firmware and software drivers. 

When the `state` runs, the `state` will mount (if required - the state can use pre-existing mount points) the NFS filesystem(s) on the node, perform the HP SUM commands and then un'mount the filesystem(s) (if required). 

This `state` can be configured to perform a `two phase` update, initially installing the drivers, then running a second time to update the firmware. This is archieved by utilising `grains` to note the point within the process, and a reactor to monitor the `minion` restart, after the assumed reboot, to trigger the second phase.

Configuration
-------------
  * Pre-steps (before running this module):
      1.  Configure a NFS Server, and configure the Linux nodes as NFS Clients (not necessary if using pre-existing NFS config)
      2.  Decide on desired use model (seperate HP SUM `rw` or `ro`, `baseline`, `iso` or `local` (after initial HP SUM `ro` run))
      3.  Use the customer's existing NFS configuration or create new NFS mountpoints.
      4.  Install HPSUM (for seperate HP SUM `rw` and `ro` options, not required for `Baseline` option) on NFS Server.
      5.  Pull latest SPP from HPE
      6.  Cut specific firmware and/or software driver repository. 
          * If use model is `rw` or `ro`, create via "Create ISO and Save Baseline" otpion.
          * If use model is `baseline`, create via "Save Baseline" option.
      7. Test to understand which drivers and firmware will be installed, in what order i.e. drivers before firware (requiring a two-phase approach), whether reboots are required, whether downgrades or rewrites are required etc.

** Note: ** To ensure that HP SUM executables are not stored locally due to a failed write test, have at least the following in the `/etc/exports` file on the NFS Server - `(rw,sync,no_root_squash,no_all_squash)`
 
  * Installation of `state` file:
      1.  Git clone this repo on the Salt Master module.
      2.  Move the `pillar.yaml` file to be under the `pillar` tree, rename to `hpsum.sls`, and configure the `pillar` top.sls as required (refresh Pillar data - `salt \* saltutil.refresh_pillar`).
      3.  Move the `hpsum.py` file to be under the `_grains` tree, and sync the `grains` as required (use `salt \* saltutil.sync_all`)
      4.  Move the `hpsum_twophase_chk.sls` file to be under the `reactors` tree.
      5.  Edit the `/etc/salt/master` file to include the following reactor (change `reactor dir` location, as required):
         - 'salt/minion/*/start':
           - /srv/reactor/hpsum/hpsum_twophase_chk.sls
      6.  Restart the salt-master as required.
      7.  Move the `hpsum` folder under the `salt` tree, and configure the `salt` top.sls as required.

  * Configuration of state:
      1.  Update the `hpsum pillar`, or `defaults.yaml` files (viable options are provided) with the desired values.


Available states
-----------------------
 * **hpsum** - runs all states
 * **hpsum.clean_local** - if value is set, will remove the local version of the HP SUM executuables on the server
 * **hpsum.dir_create** - will create the local directories for the NFS mount points.
 * **hpsum.nfs_mounts** - if not using existing customer NFS mounts, will mount NFS mounts (assumes local directories exist)
 * **hpsum.performcmd** - will perform the HP SUM command (assumes NFS mounts are available, but only runs if executable is present)
 * **hpsum.nfs_umounts** - if not using existing customer NFS mounts, will umount NFS mounts
 * **hpsum.two_phase** - performs the `two phase` process, will verify phase via grains, and set drivers or firmware selection as required.
 * **hpsum.two_phase_config** - sets up grain values for `two phase` process. Needs to be run before `two phase` process can start
 * **hpsum.two_phase_revert** - switches off the `two_phase` process during the process 

Running `two phase` process
---------------------------
* Configure the `grains` and `reactor` as described above.
* Configure `state` as a normal run.
* Set the `two_phase` process to run for the required nodes, via `salt <node list> state.sls hpsum.two_phase_config`
* Run the `hpsum.two_phase` state on desired nodes.
*    - It is assumed that `driver` phase will reboot the server (if a reboot does not occur, run `hpsum.two_phase` again)
*    - When the `minion` restarts, the `reactor` will call the `hpsum.two_phase`, and the `firmware` phase will be performed
*    - After the `firmware` phase, the grains are set to stop further `two_phase` runs, until the `hpsum.two_phase_config` is run again (it is possible to run the `hpsum` state at this point)
*    - Until this occurs, the grain `hpsum_twophase` will record `HPSUM_done`

state options
--------------

defaults.yaml options:
----------------------

`sum_type` = HP SUM NFS mount type - options are 'rw', 'ro', 'local', or 'baseline'

`nfs_sumlocallocation` = HP SUM local mount point directory - no end "/"

`local_directory` = Local HP SUM store location - no end "/"

`baseline_localfs`  = Baseline local mount point directory - no end "/"

Pillar options:
---------------

`logdir` = Logfile 'root' directory - no end "/"

`cust_nfs` = Use customers existing NFS moint points (restricts the need to mount NFS mount points)

`sumremotelocation` = HP SUM NFS exported filesystem

`baseline_remotefs` = Baseline NFS exported filesystem

`local_clean` = Remove local HP SUM store (copied over if 'ro' option is used)

`dryrun` = HP SUM option to control whether updates are made

`selection` = HP SUM option to specify whether the update will be drivers only (--softwareonly), firmware only (--romonly) or both (default, "")

`reboot` = HP SUM option to specify if a reboot is allowed and how

`downgrade` = HP SUM option to specify whether driver/firmware can be downgraded

`rewrite` = HP SUM option to specify whether driver/firmware will be re-installed

`dependency` = HP SUM option to specify error handling w/r/t missing driver/firmware.

grains and their values
-----------------------

`hpsum_run`: "", True or False

`hpsum_twophase`: "", HPSUM_drivers, HPSUM_firmware, HPSUM_done

`hpsum_selection`: "", "--romonly", "--softwareonly"
