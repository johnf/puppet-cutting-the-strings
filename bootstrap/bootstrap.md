!SLIDE transition=fade background subsection
# Bootstrap
![Bootstrap](bootstrap.png)


!SLIDE transition=fade
# put the boot in

    @@@ ruby
    desc 'Bootstrap the server with pupper'
    task :go do
      system('ssh-add amazon/default.rsa')
      hostname
      github
      upgrade
      puppet_setup
    end

!SLIDE transition=fade
# fix up the hostname

    @@@ ruby
    task :hostname do
      fqdn = ENV['FQDN'] ||
        Capistrano::CLI.ui.ask "FQDN?"
      end
      h = fqdn.split('.')[0]

      run "#{sudo} sed -i -e " .
          "'/127.0.0.1/a127.0.1.1 #{fqdn} " .
          "#{hostname}' /etc/hosts"
      run "echo #{h} | #{sudo} tee /etc/hostname"
      run "#{sudo} service hostname start"
    end

!SLIDE transition=fade
# github and apt

    @@@ ruby
    task :github do
      run "mkdir -p .ssh"
      run "echo 'github.com ssh-rsa AAAAB3...'" .
          " >> .ssh/known_hosts"
    end

    task :upgrade do
      run "#{sudo} apt-get -y update"
      run "DEBIAN_FRONTEND=noninteractive " .
          "#{sudo} -E apt-get -y dist-upgrade"
    end

!SLIDE transition=fade small
# set up puppet, github and apt

    @@@ ruby
    task :puppet_setup do
      release = capture 'lsb_release -c -s | tr -d "\n"'

      file = '/etc/apt/sources.list.d/puppetlabs.list'
      run "echo 'deb http://apt.puppetlabs.com/ " .
          "#{release} main' | #{sudo} tee #{filename}"

      run "#{sudo} apt-get -yq update"
      run "#{sudo} apt-get install -y libaugeas-ruby"
      run "#{sudo} apt-get install -y puppet git"

      run "cd /tmp && " .
          "git clone git@github.com:vquence/puppet"
      run "#{sudo} mv /tmp/puppet /srv/puppet"

      run "cd /srv/puppet && #{sudo} puppet apply " .
          "--modulepath modules --confdir etc " .
          "--vardir var manifests/site.pp"
    end


!SLIDE transition=fade
# Put it all together

    @@@ ruby
    task :create do
      name = ENV['name']
      ENV['FQDN'] ||= "#{name}.aws.vquence.com"
      aws.create
      sleep 20 # Give SSH time to come up
      bootstrap.go
      run "#{sudo} reboot"
    end


!SLIDE transition=fade incremental commandline
# Unleash the puppets

    $ cap bootstrap:create name=pcamp02 flavour=t1.micro
    # Insert failing live demo here
