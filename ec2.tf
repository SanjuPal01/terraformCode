resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = "vol-009f540640ac021e8"         // Give Volume ID Here
  instance_id = aws_instance.web.id
}
resource "aws_instance" "web" {
  ami               = "ami-0af7a5885e3ff0439"
  availability_zone = "eu-west-1c"
  instance_type     = "t2.micro"
  key_name          = "kinetics-ha"
  tags = {
    Name = "Test"
  }
  user_data = <<EOF
                #!/bin/bash
                while ! ls /dev/xvdf > /dev/null
                do    sleep 5
                done
                sudo yum install xfsprogs -y
                BLK_ID=$(file -s /dev/xvdf | cut -f2 -d" ")
                if [ "`echo -n $BLK_ID`" == "data" ] ; then sudo mkfs -t xfs /dev/xvdf; fi
                sudo mkdir -p /hab
                sudo mount /dev/xvdf /hab
  EOF
}
