# .ssh layout

This document describes a layout for `~/.ssh` on your client. It isn't perfect, but its documented and you don't have to guess as much as I did. I assume you know a little bit about the `ssh client`, specifically http://www.gsp.com/cgi-bin/man.cgi?topic=ssh_config or your favorite man page.

Ssh configuration has a number of sharp edges but is a little easier with version 7.3. `ProxyJump` simplifies proxy jumps, but does *not* treat keyfiles (`IdentityFile`) correctly in that it doesn't carry the proxy keys through to
its successor hosts. This means you repeat `IdentityFile` directives, once for the bastion host and then the successor, even if its the same `IdentityFile`.

Ssh client configuration is rooted in `/.ssh` and it doesn't appear you can change that or add to it. So I use this layout:

```bash
~/.ssh
├── id_rsa  # ssh default private key
├── id_rsa.pub  # ssh default public key
├── authorized_keys  # keys you'll accept
├── tmp  # convention, connection caching
├── keys.d
│   ├── mcarifio-nameshare-all.pem
│   ├── mcarifio-nameshare-all.pem.pub
│   ├── mcarifio-sitesee-all.pem
│   └── mcarifio-sitesee-all.pem.pub
├── config.d  # configuration directives, eventually included  <--- YOU ARE HERE
│   ├── encirca.d  # encirca specific, see encirca.conf below
│   │   ├── hosts.d  # specific hosts, overrides generic Host directives in encirca.conf
│   │   │   ├── nameshare.d  # specific nameshare hosts
│   │   │   │   └── README.md
│   │   │   ├── sitesee.d  # specific sitesee hosts
│   │   │   │   └── README.md
│   │   │   └── encirca.d  # specific encirca hosts
│   │   │       ├── regystar-esb-rrsk.encircalabs.com.conf.gz # by convention I gzip missing hosts
│   │   │       ├── regystar-esb-rrsk-001.encircalabs.exp.conf.gz
│   │   │       ├── regystar-esb-rrsk-001.encircalabs.alpha.conf.gz
│   │   │       ├── api.host.conf
│   │   │       ├── jenkins.host.conf
│   │   │       ├── landingpages.host.conf
│   │   │       └── esb.encircalabs.exp.host.conf
│   │   └── ssh-config  # an example ~/.ssh/config that you can use for your own ~/.ssh
│   │   └── encirca.conf
│   └── bin
│       ├── italian-autocomplete.env.sh
├── known_hosts
├── config  # ssh's default config
```

Using the debian/ubuntu convention, additional configuration directories are `${something}.d`, e.g. `keys.d` or `config.d`. The hierarchy is `config.d/${category}.d/${organization}.d/${aws}.d`.
Specific host files are suffixed with `.host.conf`, general config files are suffixed with `.conf`. This makes them easier to glob for (but makes the naming convention busy).

# Installation

In the installation below, I assume ${GITHUB_USER} is your github username, e.g. `mcarifio`. `${IAM_USER}` is your remote aws user name.
I also assume you have forked `git@github.com:EnCirca/config.d` so that you can make personal changes
without stomping others.

```bash
cd ~/.ssh
git clone git@github.com:${GITHUB_USER}/config.d
mkdir keys.d
cp <aws keys> keys.d/${IAM_USER}-${aws}-all.pem  # naming convention in ~/.ssh/config.d/**, see the layout above
```

Next, incorporate `~/.ssh/config.d/ssh-config` into `~/.ssh/config`. This may be as simple as cut-and-paste in an editor.

Finally, when you've wired up the parts, "dry run" a connection. `-vv` will tell you what config files were loaded. '-G` will tell you
the final configuration settings _for the specific host_. This is a useful debugging device.

```bash
$ ssh -vv -G ssh.encirca.com
OpenSSH_7.3p1 Ubuntu-1, OpenSSL 1.0.2g  1 Mar 2016
debug1: Reading configuration data /home/mcarifio/.ssh/config
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/encirca.d/encirca.conf
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/encirca.d/hosts.d/encirca.d/api.host.conf
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/encirca.d/hosts.d/encirca.d/esb.encircalabs.exp.host.conf
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/encirca.d/hosts.d/encirca.d/jenkins.host.conf
debug1: Reading configuration data /home/mcarifio/.ssh/config.d/encirca.d/hosts.d/encirca.d/landingpages.host.conf
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: Applying options for *
user mcarifio
hostname ssh.encirca.com
port 22
addressfamily any
batchmode no
canonicalizefallbacklocal yes
canonicalizehostname false
challengeresponseauthentication yes
checkhostip yes
compression no
controlmaster auto
enablesshkeysign no
clearallforwardings no
exitonforwardfailure no
fingerprinthash SHA256
forwardagent yes
forwardx11 no
forwardx11trusted yes
gatewayports no
gssapiauthentication yes
gssapidelegatecredentials no
hashknownhosts yes
hostbasedauthentication no
identitiesonly no
kbdinteractiveauthentication yes
nohostauthenticationforlocalhost no
passwordauthentication yes
permitlocalcommand no
protocol 2
proxyusefdpass no
pubkeyauthentication yes
requesttty auto
rhostsrsaauthentication no
rsaauthentication yes
streamlocalbindunlink no
stricthostkeychecking false
tcpkeepalive yes
tunnel false
useprivilegedport no
verifyhostkeydns false
visualhostkey no
updatehostkeys false
canonicalizemaxdots 1
compressionlevel 6
connectionattempts 1
forwardx11timeout 1200
numberofpasswordprompts 3
serveralivecountmax 3
serveraliveinterval 30
ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,3des-cbc
hostkeyalgorithms ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-rsa
hostbasedkeytypes ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-rsa
kexalgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1
loglevel DEBUG2
macs umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
pubkeyacceptedkeytypes ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-rsa
xauthlocation /usr/bin/xauth
identityfile ~/.ssh/id_rsa
identityfile ~/.ssh/id_dsa
identityfile ~/.ssh/id_ecdsa
identityfile ~/.ssh/id_ed25519
canonicaldomains
globalknownhostsfile /etc/ssh/ssh_known_hosts /etc/ssh/ssh_known_hosts2
userknownhostsfile ~/.ssh/known_hosts ~/.ssh/known_hosts2
sendenv LANG
sendenv LC_*
connecttimeout none
tunneldevice any:any
controlpersist no
escapechar ~
ipqos lowdelay throughput
rekeylimit 0 0
streamlocalbindmask 0177

$ source ~/.ssh/config.d/bin/italian-autocomplete.env.sh  # autocomplete ssh <host>
```

Connect to a few places:

```bash
ssh ssh.encircalabs.com
ssh ssh.namesharelabs.com
ssh jenkins
```





