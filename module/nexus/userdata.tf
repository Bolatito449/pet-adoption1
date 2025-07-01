
locals {
  userdata = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y wget java-1.8.0-openjdk.x86_64
sudo mkdir -p /app && cd /app
sudo wget https://download.sonatype.com/nexus/3/nexus-3.66.0-02-unix.tar.gz
sudo tar -xvf nexus-3.66.0-02-unix.tar.gz
sudo mv nexus-3.66.0-02 nexus
sudo adduser nexus
sudo mkdir -p /app/sonatype-work
sudo chown -R nexus:nexus /app/nexus /app/sonatype-work
echo 'run_as_user="nexus"' | sudo tee /app/nexus/bin/nexus.rc
sed -i '2s/.*/-Xms512m/' /app/nexus/bin/nexus.vmoptions
sed -i '3s/.*/-Xmx512m/' /app/nexus/bin/nexus.vmoptions
sed -i '4s/.*/-XX:MaxDirectMemorySize=512m/' /app/nexus/bin/nexus.vmoptions
cat <<EOT | sudo tee /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
User=nexus
Group=nexus
WorkingDirectory=/app/nexus
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Environment="JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64"
Environment="INSTALL4J_ADD_VM_PARAMS=-Xms1024M -Xmx2048M -XX:MaxDirectMemorySize=1024M"
ExecStart=/bin/bash /app/nexus/bin/nexus start
ExecStop=/bin/bash /app/nexus/bin/nexus stop
TimeoutStartSec=300
LimitNOFILE=65536
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=${var.nr-key} NEW_RELIC_ACCOUNT_ID=${var.nr-id} /usr/local/bin/newrelic install -y
sudo hostnamectl set-hostname Nexus
EOF
}


