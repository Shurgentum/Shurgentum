# Create default EC2 key pair
resource "aws_key_pair" "eks_kp" {
  key_name   = "eks_kp"
  public_key = var.public_key
}
