Automated Desktop Setup
=======================

This is my private setup, but feel free to fork and use.
Check out were I forked it from before I changed everything :).

Requires ansible.

```
sudo apt-get install -y -qq python python-pip git git-core openssh-server

sudo pip install ansible
```

Try this if ansible fails to install:
```    
    sudo apt-get -y install python-dev
    sudo apt-get -y install libffi-dev
    sudo apt-get -y install libssl-dev

```


## Known issues

-  file mode must be a string https://github.com/ansible/ansible-modules-core/issues/4064
