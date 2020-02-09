resource "aws_iam_role" "role" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = var.role_assume_role_policy
}

resource "aws_iam_role_policy_attachment" "role-attach-policy" {
  role       = aws_iam_role.role.name
  policy_arn = var.role_policy_arn
}

resource "aws_iam_role_policy_attachment" "role-attach-policy-logs" {
  role       = aws_iam_role.role.name
  policy_arn = var.role_policy_logs_arn
}
