resource "aws_instance" "hello-world" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.webserver_sg.id}"]
  availability_zone      = "${var.az}"
  key_name               = "terraform"
  iam_instance_profile   = "${aws_iam_instance_profile.ec2_profile.name}"
  tags = {
    Name       = "Hello world"
    OwnerEmail = "terraform@ilearnxl.com"
    Project = "iam-role-demo"
  }
  user_data = <<-EOF
 #!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    /usr/bin/apt-get update
    DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get upgrade -yq
    /usr/bin/apt-get install apache2 -y
    /usr/sbin/ufw allow in "Apache Full"
    /bin/echo "Hello world " >/var/www/html/index.html
    instance_ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    echo $instance_ip >>/var/www/html/index.html
    EOF

}
