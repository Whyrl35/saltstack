
cis_2500_remove_freevxfs:
  file.managed:
    - name: /etc/modprobe.d/freevxfs.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install freevxfs /bin/true"
  kmod.absent:
    - name: freevxfs
    - persist: true
    - onchanges:
      - file: cis_2500_remove_freevxfs

cis_2501_remove_jffs2:
  file.managed:
    - name: /etc/modprobe.d/jffs2.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install jffs2 /bin/true"
  kmod.absent:
    - name: jffs2
    - persist: true
    - onchanges:
      - file: cis_2501_remove_jffs2

cis_2502_remove_hfs:
  file.managed:
    - name: /etc/modprobe.d/hfs.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install hfs /bin/true"
  kmod.absent:
    - name: hfs
    - persist: true
    - onchanges:
      - file: cis_2502_remove_hfs

cis_2503_remove_hfsplus:
  file.managed:
    - name: /etc/modprobe.d/hfsplus.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install hfsplus /bin/true"
  kmod.absent:
    - name: hfsplus
    - persist: true
    - onchanges:
      - file: cis_2503_remove_hfsplus

cis_2504_remove_squashfs:
  file.managed:
    - name: /etc/modprobe.d/squashfs.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install squashfs /bin/true"
  kmod.absent:
    - name: squashfs
    - persist: true
    - onchanges:
      - file: cis_2504_remove_squashfs

cis_2505_remove_udf:
  file.managed:
    - name: /etc/modprobe.d/udf.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install udf /bin/true"
  kmod.absent:
    - name: udf
    - persist: true
    - onchanges:
      - file: cis_2505_remove_udf

#XXX: vfat is used to mount efi space, check if this realy apply
#cis_2506_remove_vfat:
#  file.managed:
#    - name: /etc/modprobe.d/vfat.conf
#    - user: root
#    - group: root
#    - mode: "0600"
#    - contents: "install vfat /bin/true"
#  kmod.absent:
#    - name: vfat
#    - persist: true
#    - onchanges:
#      - file: cis_2506_remove_vfat

#cis_2507
#...
#cis_2521
#TODO: check if partitioning over cloud is possible and needed
#TODO: need to reboot in rescue, make partition + lvm, build image and use it in future

cis_2522_shm_noexec:
  mount.mounted:
    - name: /dev/shm
    - device: tmpfs
    - fstype: tmpfs
    - opts: rw,nosuid,nodev,noexec
    - persist: False

cis_2524_disable_usb_storage:
  file.managed:
    - name: /etc/modprobe.d/usb-storage.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install usb-storage /bin/true"
  kmod.absent:
    - name: usb-storage
    - persist: true
    - onchanges:
      - file: cis_2524_disable_usb_storage

