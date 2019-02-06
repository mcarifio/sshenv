# .ssh layout

This document describes a layout for `~/.ssh` on your client. It isn't perfect, but its documented and you don't have to guess as much as I did. I assume you know a little bit about the `ssh client`, specifically http://www.gsp.com/cgi-bin/man.cgi?topic=ssh_config or your favorite man page.

Ssh configuration has a number of sharp edges but is a little easier with version 7.3. `ProxyJump` simplifies proxy jumps, but does *not* treat keyfiles (`IdentityFile`) correctly in that it doesn't carry the proxy keys through to
its successor hosts. This means you repeat `IdentityFile` directives, once for the bastion host and then the successor, even if its the same `IdentityFile`.

Ssh "per-user" client configuration is rooted in `/.ssh`. So I use this layout:

```bash
.ssh
├── attic/ # personal convention, move stuff out of the way
├── authorized_keys  # passwordless ssh, controlled by ssh
├── config # copy or symbolic link of ~/.ssh/config.d/sshit/config
├── config.d
│   └── sshit
│       ├── bin
│       │   ├── mkhost.sh
│       ├── environment
│       ├── .gitignore
│       ├── hosts.d
│       │   ├── mike.carif.io.host.conf
│       ├── rc
│       ├── README.md
│       ├── ssh-defaults.conf
│       └── ssh-hosts.conf
├── id_rsa
├── id_rsa.pub
├── keys.d
│   ├── aws_git_rsa # ... your personal keys here
├── known_hosts  # ssh generates
├── tmp/ # personal convention for sessions
```

Using the debian/ubuntu convention, additional configuration directories are `${something}.d`, e.g. `keys.d` or `config.d`. The hierarchy is `config.d/sshit/hosts.d/*.host.conf`. All known hosts are included.
Configuration that isn't host specific ends with `.ssh.conf`.

# Installation

Fork [sshit](https://www.github.com/mcarifio/sshit) using (say) [hub](https://hub.github.com/hub.1.html) and run `bin/hookup.sh` (to be supplied):

```bash
user=$(git config --get github.user)  ## or your github username
echo ${user}  ## should be something
mkdir -p ~/.ssh/config.d; cd $_
git clone https://www.github.com/mcarifio/sshit ; cd sshit
hub fork
git remote add -f ${user} git@github.com:${user}/sshit.git
git remote -v ## show at least two remotes, ${user} and origin
bin/hookup.sh  ## make symbolic links up to ~/.ssh/{config,rc,environment}

ssh -vvv -G localhost | less  # review log
ssh localhost  ## works?
```

# Usage

# Other Clients

You should install [mosh]() and [autossh](). They both deal with ssh timeouts (but in different ways).


# References

Unfortunately there's a lot of confusing information about ssh, ssh_config, sshd_config, ssh port forwarding with/without X11 and multihop ssh sessions using `ProxyCommand`. Here's some information I found current and useful. Of course it will become quickly dated itself, sigh.

* [canonicalization of names](https://dotfiles.tnetconsulting.net/articles/2016/0109/ssh-canonicalization.html)
* [ssh keys](https://dotfiles.tnetconsulting.net/articles/2015/0506/empowering-openssh.html)


