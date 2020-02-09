data "template_file" "policy_content" {
  template = var.policy_content

  vars = {
    aws_region      = var.aws_region
    aws_account     = var.aws_account
    target_resource = var.target_resource
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = var.policy_description
  policy      = data.template_file.policy_content.rendered
}