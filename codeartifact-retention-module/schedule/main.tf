data "aws_arn" "repository_arn" {
  arn = var.repository_arn
}

data "aws_arn" "lambda_arn" {
  arn = var.lambda_arn
}

locals {
  lambda_function_name = replace(data.aws_arn.lambda_arn.resource, "function:", "")
  aws_cloudwatch_event_rule_name = format("%s-%s-%s",
    var.rule_name_prefix,
    data.aws_arn.repository_arn.region,
    replace(replace(data.aws_arn.repository_arn.resource, "repository/", ""), "/", "-")
  )
}

resource "aws_cloudwatch_event_rule" "codeartifact_retention_schedule" {
  name = substr(local.aws_cloudwatch_event_rule_name, 0, 64)
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "codeartifact_retention_schedule" {
  rule = aws_cloudwatch_event_rule.codeartifact_retention_schedule.name
  arn = var.lambda_arn

  input = jsonencode({
    repository_arn = var.repository_arn
    days_to_retain = var.days_to_retain
  })
}

resource "aws_lambda_permission" "codeartifact_retention_schedule" {
  statement_id = aws_cloudwatch_event_rule.codeartifact_retention_schedule.name
  action = "lambda:InvokeFunction"
  function_name = local.lambda_function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.codeartifact_retention_schedule.arn
}
