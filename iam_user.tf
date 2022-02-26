resource "aws_iam_user" "test-user1" {
  name = "test-user1"
  tags = {
    Description = "Test User 1"
  }
}