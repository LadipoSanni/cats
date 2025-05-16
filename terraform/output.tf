output "codedeploy_app_name" {
  value       = aws_codedeploy_app.app.name
  description = "Name of the CodeDeploy application."
}

output "codedeploy_deployment_group_name" {
  value       = aws_codedeploy_deployment_group.dg.deployment_group_name
  description = "Name of the CodeDeploy deployment group."
}

output "alb_dns_name" {
  value       = aws_elb.app_elb.dns_name
  description = "DNS name of the Application Load Balancer."
}

output "alb_target_group_arn" {
  value       = aws_elb.app_elb.arn
  description = "ARN of the Application Load Balancer."
}

output "asg_name" {
  value       = aws_autoscaling_group.app_asg.name
  description = "Name of the Auto Scaling Group."
}

output "ec2_instance_ids" {
  value       = aws_autoscaling_group.app_asg.instances
  description = "EC2 instance IDs in the Auto Scaling Group."
}

output "codedeploy_role_arn" {
  value       = aws_iam_role.codedeploy_role.arn
  description = "ARN of the IAM role used by CodeDeploy."
}
