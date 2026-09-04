# =============================================================================
# alb_placeholder.tf — NOT created by default (costs money every hour)
# =============================================================================
# Application Load Balancer + ACM certificates are Phase 10 advanced topics.
# enable_alb stays false. When you are ready (and accept ~$16+/month ALB cost):
#
# 1. Create VPC / subnets (or use default VPC carefully)
# 2. Create aws_lb + aws_lb_target_group + aws_lb_listener
# 3. Request ACM certificate for your domain
# 4. Point Route53 (optional) at the ALB
#
# Prefer keeping this OFF while learning. Use LocalStack + kind for free testing.
# =============================================================================

# Intentionally empty — documentation only. See README Phase 10.
