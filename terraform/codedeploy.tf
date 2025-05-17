resource "aws_codedeploy_app" "app" {
  name             = "sinatra-codedeploy-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "dg" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "sinatra-deployment-group"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime" # Canary deployment option

  auto_scaling_groups = [aws_autoscaling_group.app_asg.name]

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_success_option = "STOP_DEPLOYMENT"
  }

  load_balancer_info {
    elb_info {
      name = aws_elb.app_elb.name
    }
  }

  alarm_configuration {
    enabled          = true
    alarms           = ["${aws_cloudwatch_metric_alarm.deployment_alarm.name}"]
    ignore_poll_alarm_failure = false
  }
}
