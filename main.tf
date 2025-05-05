provider "aws" {
  region = var.aws_region
}

# ---------------------------
# 1. SNS Topic for Alerts
# ---------------------------
resource "aws_sns_topic" "budget_alerts" {
  name = "aws-budget-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# ---------------------------
# 2. AWS Budget Configuration
# ---------------------------
resource "aws_budgets_budget" "monthly_cost" {
  name              = "monthly-cost-budget"
  budget_type       = "COST"
  limit_amount      = var.monthly_budget_amount
  limit_unit       = "USD"
  time_unit        = "MONTHLY"
  time_period_start = "2025-01-01_00:00"
  time_period_end   = "2087-06-15_00:00" # Far future date

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                 = var.alert_threshold_percentage
    threshold_type            = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.notification_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                 = 4
    threshold_type            = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notification_email]
  }
}

# ---------------------------
# 3. CloudWatch Billing Alarm
# ---------------------------
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "monthly-billing-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace          = "AWS/Billing"
  period             = 21600 # 6 hours
  statistic          = "Maximum"
  threshold          = var.monthly_budget_amount
  alarm_description  = "Alerts when AWS charges exceed budget"
  alarm_actions      = [aws_sns_topic.budget_alerts.arn]
  ok_actions         = [aws_sns_topic.budget_alerts.arn]

  dimensions = {
    Currency = "USD"
  }
}