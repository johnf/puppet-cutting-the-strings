!SLIDE transition=fade background subsection
# Fog
![Fog](fog.png)


!SLIDE transition=fade
# Set up

    @@@ ruby
    require 'fog'

    def compute
      @compute ||= Fog::Compute.new(
        :provider              => 'AWS',
        :aws_secret_access_key => 'awu...',
        :aws_access_key_id     => '05Z...',
      )
    end

    def servers
      @servers ||= compute.servers
    end

!SLIDE transition=fade
# Create instance

    @@@ ruby
    task :create do
      flavour = ENV['flavour']
      name    = ENV['name']

      server = servers.create(
        :image_id       => 'ami-a29943cb'
        :availability_zone => 'us-east-1c',
        :flavor_id      => flavour,
        :key_name       => 'default',
        :tags           => { 'Name' => name },
      )
      server.wait_for { ready? }
      server.reload
      p server
    end

!SLIDE transition=fade commandline incremental
# Create instance

    $ cap aws:create flavour=t1.micro name=pcamp01
    * executing `aws:create'
    Creating Instance...
    <Fog::Compute::AWS::Server
        id="i-dcb76ca5",
        availability_zone="us-east-1c",
        block_device_mapping=[{"deviceName"=>"/dev/sda1",
          "volumeId" =>"vol-119f1f7f",
          "status"   =>"attached"}],
        dns_name="ec2-184-72-141-41.compute-1.amazonaws.com",
        groups=["sg-f3c3269a", "default"],
        flavor_id="t1.micro",
        image_id="ami-a29943cb",
        kernel_id="aki-825ea7eb",
        key_name="default",
        created_at=2012-06-07 13:46:50 UTC,
        private_dns_name="ip-10-122-215-114.ec2.internal",
        private_ip_address="10.122.215.114",
        public_ip_address="184.72.141.41",
        root_device_type="ebs",
        state="running",
        tags={"Name"=>"pcamp01"},
    >

!SLIDE transition=fade
# Listing instances

    @@@ ruby
    desc 'List current AWS instances'
    task :list do
      f = '%-15s  %-10s  %-8s  %-10s ...'
      puts format % %w{Name ID State DNS ...}
      servers.each do |s|
        puts format % [ s.tags['Name'], ... ]
      end
    end


!SLIDE transition=fade commandline incremental
# Listing instances

    $ cap aws:list
    * executing `aws:list'
    Name    ID         State   Zone       Type
    pcamp01 i-dcb76ca5 running us-east-1c t1.micro
    pcamp02 i-5b62e03e running us-east-1c m1.small

!SLIDE transition=fade
# Other Useful bits

    @@@ ruby
    task :show do
      instance_id = ENV['instance_id']
      p servers.get instance_id
    end

    task :start do
      instance_id = ENV['instance_id']
      servers.get(instance_id).start
    end

    task :stop do
      instance_id = ENV['instance_id']
      force = ENV['force'] =~ /^true$/i
      server = servers.get(instance_id).stop(force)
    end
