Automated Desktop Setup
=======================

This is my private setup, but feel free to fork and use.
Check out were I forked it from before I changed everything :).

Requires ansible.

```
sudo apt-get install -y -qq python3-pip git git-core openssh-server

sudo pip3 install ansible
```

Try this if ansible fails to install:
```    
    sudo apt-get -y install python-dev
    sudo apt-get -y install libffi-dev
    sudo apt-get -y install libssl-dev

```

## Remember to noatime for SSD
/etc/fstab - add `noatime,` to all SSDs options column

remove swap configuration if any


## Known issues

-  file mode must be a string https://github.com/ansible/ansible-modules-core/issues/4064


## TODO

- Add "no internet" app runner http://ubuntuforums.org/showthread.php?t=1188099&s=73e8a8809da60f5e49641129388c7658
