# Create an instance
resource "aws_instance" "web" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = var.default_az
  key_name          = aws_key_pair.eks_kp.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nic.id
  }
  tags = {
    Name = "test"
  }
}
