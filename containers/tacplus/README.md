# README

# # Documentation URLs

<https://sysadmins.tech/setting-up-tacacs-on-linux-2024-update/>
<https://networklessons.com/security/how-to-install-tacacs-on-linux-centos>

## Sample configuration file

This should go into the node definition

```plain
accounting file = /var/log/tacacs/acct.log
access log = /var/log/tacacs/tacacs.log

key = tacacs123

acl = default {
  permit = 10\.32\.0\.10
}

host = 10.32.0.10 {
  prompt = "TACPLUS auth: "
}

group = netadmin {
  default service = permit
  service = exec {
    priv-lvl = 15
  }
}
group = netoper {
  default service = permit
  service = exec {
    priv-lvl = 1
  }
}
user = unknown {
  login = cleartext admin123
  member = netadmin
}
user = $enab15$ {
  login = cleartext admin123
}

user = tacadmin {
  login = cleartext admin123
  member = netadmin
}

user = tacoper {
  login = cleartext oper123
  member = netoper
}

```
