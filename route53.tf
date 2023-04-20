

resource "aws_route53_record" "appserver" {
    zone_id = data.aws_route53_zone.my_created_hosted_zone.zone_id
    name = "appserver.nritworld.xyz"
    type = "A"
    ttl = 300
    records = [ aws_instance.my_task_checking.public_ip ]

  
}

data "aws_route53_zone" "my_created_hosted_zone" {
  name = "nritworld.xyz"
  
}
/* 
resource "aws_lb" "domain-alb" {
  name = "my-load-balancer"
  count = length(var.subnet_cidrs_public)
  subnets = ["ap-south-1a"]
  security_groups = [ aws_security_group.test_security_group.id ]
  internal = false

}

resource "aws_lb_listener" "alb_front_http" {
    load_balancer_arn = aws_lb.domain-alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.test_target_group.arn
    }
}

resource "aws_lb_target_group" "lb_target_group_http" {
    name = "my-alb-target-group"
    vpc_id = aws_vpc.test-env.id
    port = 80
    protocol = "HTTP"
    health_check {
      interval = 5
      path = "/healthcheck"
      port = 80
      protocol = "HTTP"
      healthy_threshold = 3
      unhealthy_threshold = 5
      timeout = 5
      matcher = "200-308"
    }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
    target_group_arn = aws_lb_target_group.lb_target_group_http.arn
    target_id = aws_instance.my_task_checking.id
    port = 80
} */

/* resource "aws_elb" "domain-elb" {
    name = "aws-testing-doamin-elb"
    count = length(var.availability_zones)
    availability_zones = [ var.availability_zones[count.index] ]
    schema = "internet-facing"

    listener {
      instance_port = 80
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }
} */

