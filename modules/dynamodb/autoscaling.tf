# resource "aws_appautoscaling_target" "read_target" {
#   count = var.read_capacity_autoscaling.enabled ? 1 : 0

#   max_capacity       = var.read_capacity_autoscaling.max_capacity
#   min_capacity       = var.read_capacity_autoscaling.min_capacity
#   resource_id        = "table/${aws_dynamodb_table.table.name}"
#   scalable_dimension = "dynamodb:table:ReadCapacityUnits"
#   service_namespace  = "dynamodb"
# }

# resource "aws_appautoscaling_policy" "read_policy" {
#   count = var.read_capacity_autoscaling.enabled ? 1 : 0

#   name               = "DynamoDBReadCapacityUtilization"
#   service_namespace  = "dynamodb"
#   resource_id        = "table/${aws_dynamodb_table.table.name}"
#   scalable_dimension = "dynamodb:table:ReadCapacityUnits"
#   policy_type        = "TargetTrackingScaling"

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBReadCapacityUtilization"
#     }
#     target_value = var.read_capacity_autoscaling.usage_percentage
#   }
# }

# resource "aws_appautoscaling_target" "write_target" {
#   count = var.write_capacity_autoscaling.enabled ? 1 : 0

#   max_capacity       = var.write_capacity_autoscaling.max_capacity
#   min_capacity       = var.write_capacity_autoscaling.min_capacity
#   resource_id        = "table/${aws_dynamodb_table.table.name}"
#   scalable_dimension = "dynamodb:table:WriteCapacityUnits"
#   service_namespace  = "dynamodb"
# }

# resource "aws_appautoscaling_policy" "write_policy" {
#   count = var.write_capacity_autoscaling.enabled ? 1 : 0

#   name               = "DynamoDBWriteCapacityUtilization"
#   service_namespace  = "dynamodb"
#   resource_id        = "table/${aws_dynamodb_table.table.name}"
#   scalable_dimension = "dynamodb:table:WriteCapacityUnits"
#   policy_type        = "TargetTrackingScaling"

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBWriteCapacityUtilization"
#     }
#     target_value = var.write_capacity_autoscaling.usage_percentage
#   }
# }
