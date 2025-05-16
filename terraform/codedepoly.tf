resource "aws_codedeploy_app" "app" {
  name = "${var.app_name}-codedeploy"
  compute_platform = "Server"
}

resource "aws_iam_role" "codedeploy_role" {
  name = "${var.app_name}-CodeDeployRole"

  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_deployment_group" "app_dg" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = "${var.app_name}-dg"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce" # Change to Blue/Green or Canary configs

  autoscaling_groups = [aws_autoscaling_group.app_asg.name]

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  load_balancer_info {
    target_group_pair_info {
      target_groups = [aws_lb_target_group.app_tg.name]
      prod_traffic_route {
        listener_arn = aws_lb_listener.http.arn
      }
      test_traffic_route {
        listener_arn = aws_lb_listener.http.arn
      }
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
