resource "aws_iam_user" "test-user" {
  name = "test-user"
  tags = {
    Description = "Test User"
  }
}