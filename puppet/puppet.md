!SLIDE transition=fade background subsection
# Puppet
![Puppet](puppet.png)

!SLIDE transition=fade
# almost nothing changes

!SLIDE transition=fade commandline incremental

    $ ls /srv/puppet
    .── amazon
    ├── bin
    ├── capistrano
    ├── etc
    ├── manifests
    │   ├── nodes
    │   └── roles
    └── modules
        ├── apt
        ├── beanstalk
        ├── collectd
        ├── crawler
        ├── ssh
        └── user

    $ cat /srv/puppet/etc/puppet.conf
    [main]
    show_diff = true

!SLIDE transition=fade commandline incremental

# Performing a puppet run

    $ sudo puppet apply --modulepath modules \
           --confdir etc --vardir var \
           manifests/site.pp --verbose
