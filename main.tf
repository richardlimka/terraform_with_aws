resource "aws_iam_user" "admin-user" {
  name = "lucy1"
  tags = {
      Description = "Technical Team Leader"
  }
}

