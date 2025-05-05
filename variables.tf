variable "monthly_budget_amount" {
  description = "Monthly budget amount in USD"
  type        = number
  default     = 5
}

variable "alert_threshold_percentage" {
  description = "Percentage of budget to trigger alerts"
  type        = number
  default     = 5
}

variable "notification_email" {
  description = "Email address for budget alerts"
  type        = string
  default = "vincent.umehj@gmail.com"
}

variable "aws_region" {
  description = "AWS region for resources"
  default     = "eu-west-1"
}