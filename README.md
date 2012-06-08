# Cutting the strings: masterless puppet

In smaller environments (and sometimes even bigger ones), running a puppet
master can be an unneeded overhead and complexity. John will discuss how he uses
Puppet to manage 2-3 servers at his siblings small businesses as well as how
this scales to managing 100+ machines in the cloud at Vquence using a
combination of, git, Capistrano and Fog.

# Intructions

``` bash
git clone git://github.com/johnf/puppet-cutting-the-strings.git
cd /puppet-cutting-the-strings
bundle
./setup.sh
```
