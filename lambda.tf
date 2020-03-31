resource "aws_lambda_function" "proba-tanium" {
  function_name = "proba-tanium"

  filename      = "proba.zip"

  handler = "lambda_function.lambda_handler"
  runtime  = "python3.7"

  role  = "${aws_iam_role.tanium_compliance_check_policy.arn}"
}

resource "aws_iam_role" "tanium_compliance_check_policy" {
   name = "tanium_compliance_check_policy"

   assume_role_policy = <<EOF
 {
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
      ]
 }
EOF
}

resource "aws_cloudwatch_event_rule" "start_rule" {
  name        = "cwrule_framg_start_tanium_check"
  description = "tanium start"

  schedule_expression = "cron(00 23 * * ? *)"

}

resource "aws_cloudwatch_event_target" "start_rule" {
  rule  = "${aws_cloudwatch_event_rule.start_rule.name}"
  arn   = "${aws_lambda_function.proba-tanium.arn}"
}



resource "aws_cloudwatch_event_rule" "stop_rule" {
  name        = "cwrule_framg_stop_tanium_check"
  description = "tanium stop"

  schedule_expression = "cron(00 00 * * ? *)"

}

resource "aws_cloudwatch_event_target" "stop_rule" {
  rule  = "${aws_cloudwatch_event_rule.stop_rule.name}"
  arn   = "${aws_lambda_function.proba-tanium.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.proba-tanium.function_name}"
  principal      = "events.amazonaws.com"
  #source_account = "${data.aws_caller_identity.current.311665893805 }"
  source_arn     = "${aws_cloudwatch_event_rule.start_rule.arn}"
  #source_arn     = "${aws_cloudwatch_event_rule.stop_rule.arn}"
}
