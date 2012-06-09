!SLIDE transition=fade background subsection
# Capistrano
![Capistrano](capistrano.png)

!SLIDE transition=fade small
# Day to day

    @@@ ruby
    namespace :puppet do
    task :go do
      options = ENV['options']
      system 'git push'
      run "cd /srv/puppet && git pull --quiet"
      run "cd /srv/puppet && #{sudo} puppet apply " .
          "--modulepath modules --confdir etc " .
          "--vardir var --verbose manifests/site.pp " .
          options
    end

!SLIDE transition=fade commandline incremental
# Day to day

    $ cap puppet:go HOSTFILTER=pcamp01.vq.com options="--noop"
      * executing `puppet:go'
      * executing `puppet:update'
    Everything up-to-date
      * executing "cd /srv/puppet && git pull --quiet"
        servers: ["db01.aws.vquence.com"]
        [db01.aws.vquence.com] executing command
        command finished in 2889ms
      * executing "cd /srv/puppet && sudo -p 'sudo password: ' puppet apply --modulepath modules --confdir etc --vardir var --verbose manifests/site.pp --noop"
        servers: ["db01.aws.vquence.com"]
        [db01.aws.vquence.com] executing command
     <Everyone know what a puppet run looks like by now :)>
        command finished in 793ms

