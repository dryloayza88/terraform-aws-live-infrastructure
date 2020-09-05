provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "..\/..\/..\/..\/modules\/services\/webserver-cluster"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-diego"
  db_remote_state_key = "stage/services/webserver-cluster/terraform.tfstate"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  from_port = 12345
  protocol = "tcp"
  security_group_id = module.webserver_cluster.alb_security_group_id
  to_port = 12345
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_autoscaling_schedulea" "scale_out_during_business_hours" {
  autoscaling_group_name  = module.webserver_cluster.asg_name
  scheduled_action_name   = "scale-out-during-business-hours"
  min_size                = 2
  max_size                = 10
  desired_capacity        = 10
  recurrence              = "0 9 * * *"
}

resource "aws_autoscaling_schedulea" "sscale_in_at_night" {
  autoscaling_group_name  = module.webserver_cluster.asg_name
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"
}
