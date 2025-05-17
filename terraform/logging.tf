resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/sinatra-app/logs"
  retention_in_days = 14
}
