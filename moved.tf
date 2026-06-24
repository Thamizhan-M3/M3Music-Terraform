moved {
  from = aws_dynamodb_table.upload_events
  to   = module.database.aws_dynamodb_table.upload_events
}

moved {
  from = aws_sqs_queue.upload_events_dlq
  to   = module.messaging.aws_sqs_queue.upload_events_dlq
}

moved {
  from = aws_sqs_queue.upload_events_queue
  to   = module.messaging.aws_sqs_queue.upload_events_queue
}

moved {
  from = aws_sqs_queue_policy.upload_events_from_s3
  to   = module.messaging.aws_sqs_queue_policy.upload_events_from_s3
}

moved {
  from = aws_sns_topic.hourly_upload_report
  to   = module.messaging.aws_sns_topic.hourly_upload_report
}

moved {
  from = aws_sns_topic_subscription.admin_email
  to   = module.messaging.aws_sns_topic_subscription.admin_email
}

moved {
  from = aws_sns_topic.upload_reports
  to   = module.messaging.aws_sns_topic.upload_reports
}

moved {
  from = helm_release.kube_prometheus_stack[0]
  to   = module.monitoring.helm_release.kube_prometheus_stack[0]
}

moved {
  from = helm_release.argocd
  to   = module.gitops.helm_release.argocd
}

moved {
  from = aws_vpc.main
  to   = module.vpc.aws_vpc.main
}

moved {
  from = aws_subnet.bastionhost_subnet_a
  to   = module.vpc.aws_subnet.bastionhost_subnet_a
}

moved {
  from = aws_subnet.bastionhost_subnet_b
  to   = module.vpc.aws_subnet.bastionhost_subnet_b
}

moved {
  from = aws_subnet.frontend_subnet_a
  to   = module.vpc.aws_subnet.frontend_subnet_a
}

moved {
  from = aws_subnet.frontend_subnet_b
  to   = module.vpc.aws_subnet.frontend_subnet_b
}

moved {
  from = aws_subnet.backend_subnet_a
  to   = module.vpc.aws_subnet.backend_subnet_a
}

moved {
  from = aws_subnet.backend_subnet_b
  to   = module.vpc.aws_subnet.backend_subnet_b
}

moved {
  from = aws_subnet.database_subnet_a
  to   = module.vpc.aws_subnet.database_subnet_a
}

moved {
  from = aws_subnet.database_subnet_b
  to   = module.vpc.aws_subnet.database_subnet_b
}

moved {
  from = aws_internet_gateway.igw
  to   = module.vpc.aws_internet_gateway.igw
}

moved {
  from = aws_eip.nat_eip
  to   = module.vpc.aws_eip.nat_eip
}

moved {
  from = aws_nat_gateway.nat_gateway
  to   = module.vpc.aws_nat_gateway.nat_gateway
}

moved {
  from = aws_route_table.public_route_table
  to   = module.vpc.aws_route_table.public_route_table
}

moved {
  from = aws_route_table.private_route_table
  to   = module.vpc.aws_route_table.private_route_table
}

moved {
  from = aws_route_table_association.bastionhost_subnet_a_association
  to   = module.vpc.aws_route_table_association.bastionhost_subnet_a_association
}

moved {
  from = aws_route_table_association.bastionhost_subnet_b_association
  to   = module.vpc.aws_route_table_association.bastionhost_subnet_b_association
}

moved {
  from = aws_route_table_association.frontend_subnet_a_association
  to   = module.vpc.aws_route_table_association.frontend_subnet_a_association
}

moved {
  from = aws_route_table_association.frontend_subnet_b_association
  to   = module.vpc.aws_route_table_association.frontend_subnet_b_association
}

moved {
  from = aws_route_table_association.backend_subnet_a_association
  to   = module.vpc.aws_route_table_association.backend_subnet_a_association
}

moved {
  from = aws_route_table_association.backend_subnet_b_association
  to   = module.vpc.aws_route_table_association.backend_subnet_b_association
}

moved {
  from = aws_route_table_association.database_subnet_a_association
  to   = module.vpc.aws_route_table_association.database_subnet_a_association
}

moved {
  from = aws_route_table_association.database_subnet_b_association
  to   = module.vpc.aws_route_table_association.database_subnet_b_association
}

moved {
  from = aws_vpc_endpoint.s3_endpoint
  to   = module.vpc.aws_vpc_endpoint.s3_endpoint
}

moved {
  from = aws_security_group.frontend_alb_sg
  to   = module.vpc.aws_security_group.frontend_alb_sg
}

moved {
  from = aws_security_group.frontend_sg
  to   = module.vpc.aws_security_group.frontend_sg
}

moved {
  from = aws_security_group.backend_alb_sg
  to   = module.vpc.aws_security_group.backend_alb_sg
}

moved {
  from = aws_security_group.backend_sg
  to   = module.vpc.aws_security_group.backend_sg
}

moved {
  from = aws_security_group.database_sg
  to   = module.vpc.aws_security_group.database_sg
}

moved {
  from = aws_security_group.lambda_sg
  to   = module.vpc.aws_security_group.lambda_sg
}

moved {
  from = aws_security_group_rule.mongodb_from_backend
  to   = module.vpc.aws_security_group_rule.mongodb_from_backend
}

moved {
  from = aws_security_group_rule.mongodb_from_lambda
  to   = module.vpc.aws_security_group_rule.mongodb_from_lambda
}

moved {
  from = aws_security_group_rule.database_all_egress
  to   = module.vpc.aws_security_group_rule.database_all_egress
}

moved {
  from = aws_security_group_rule.mongodb_from_eks_nodes
  to   = module.eks.aws_security_group_rule.mongodb_from_eks_nodes
}

moved {
  from = aws_iam_role.eks_cluster_role
  to   = module.eks.aws_iam_role.eks_cluster_role
}

moved {
  from = aws_iam_role_policy_attachment.eks_cluster_policy
  to   = module.eks.aws_iam_role_policy_attachment.eks_cluster_policy
}

moved {
  from = aws_eks_cluster.main
  to   = module.eks.aws_eks_cluster.main
}

moved {
  from = aws_iam_role.eks_node_role
  to   = module.eks.aws_iam_role.eks_node_role
}

moved {
  from = aws_iam_role_policy_attachment.worker_node_policy
  to   = module.eks.aws_iam_role_policy_attachment.worker_node_policy
}

moved {
  from = aws_iam_role_policy_attachment.cni_policy
  to   = module.eks.aws_iam_role_policy_attachment.cni_policy
}

moved {
  from = aws_iam_role_policy_attachment.ecr_policy
  to   = module.eks.aws_iam_role_policy_attachment.ecr_policy
}

moved {
  from = aws_eks_node_group.main
  to   = module.eks.aws_eks_node_group.main
}

moved {
  from = aws_eks_addon.vpc_cni
  to   = module.eks.aws_eks_addon.vpc_cni
}

moved {
  from = aws_eks_addon.coredns
  to   = module.eks.aws_eks_addon.coredns
}

moved {
  from = aws_eks_addon.kube_proxy
  to   = module.eks.aws_eks_addon.kube_proxy
}

moved {
  from = aws_iam_openid_connect_provider.eks
  to   = module.eks.aws_iam_openid_connect_provider.eks
}

moved {
  from = aws_iam_role.ebs_csi_driver_role
  to   = module.eks.aws_iam_role.ebs_csi_driver_role
}

moved {
  from = aws_iam_role_policy_attachment.ebs_csi_driver_policy
  to   = module.eks.aws_iam_role_policy_attachment.ebs_csi_driver_policy
}

moved {
  from = aws_eks_addon.ebs_csi
  to   = module.eks.aws_eks_addon.ebs_csi
}

moved {
  from = aws_eks_access_entry.github_actions
  to   = module.eks.aws_eks_access_entry.github_actions
}

moved {
  from = aws_eks_access_policy_association.github_actions_admin
  to   = module.eks.aws_eks_access_policy_association.github_actions_admin
}

moved {
  from = aws_iam_role.frontend_role
  to   = module.iam.aws_iam_role.frontend_role
}

moved {
  from = aws_iam_role.backend_role
  to   = module.iam.aws_iam_role.backend_role
}

moved {
  from = aws_iam_role.database_role
  to   = module.iam.aws_iam_role.database_role
}

moved {
  from = aws_iam_role.backend_irsa_role
  to   = module.iam.aws_iam_role.backend_irsa_role
}

moved {
  from = aws_iam_instance_profile.frontend_profile
  to   = module.iam.aws_iam_instance_profile.frontend_profile
}

moved {
  from = aws_iam_instance_profile.backend_profile
  to   = module.iam.aws_iam_instance_profile.backend_profile
}

moved {
  from = aws_iam_instance_profile.database_profile
  to   = module.iam.aws_iam_instance_profile.database_profile
}

moved {
  from = aws_iam_policy.s3_upload_policy
  to   = module.iam.aws_iam_policy.s3_upload_policy
}

moved {
  from = aws_iam_policy.cloudwatch_logs_policy
  to   = module.iam.aws_iam_policy.cloudwatch_logs_policy
}

moved {
  from = aws_iam_policy.secrets_manager_policy
  to   = module.iam.aws_iam_policy.secrets_manager_policy
}

moved {
  from = aws_iam_policy.ecr_pull_policy
  to   = module.iam.aws_iam_policy.ecr_pull_policy
}

moved {
  from = aws_iam_policy.kms_usage_policy
  to   = module.iam.aws_iam_policy.kms_usage_policy
}

moved {
  from = aws_iam_role_policy_attachment.backend_s3_attachment
  to   = module.iam.aws_iam_role_policy_attachment.backend_s3_attachment
}

moved {
  from = aws_iam_role_policy_attachment.backend_irsa_s3_attachment
  to   = module.iam.aws_iam_role_policy_attachment.backend_irsa_s3_attachment
}

moved {
  from = aws_iam_role_policy_attachment.backend_cloudwatch_attachment
  to   = module.iam.aws_iam_role_policy_attachment.backend_cloudwatch_attachment
}

moved {
  from = aws_iam_role_policy_attachment.frontend_cloudwatch_attachment
  to   = module.iam.aws_iam_role_policy_attachment.frontend_cloudwatch_attachment
}

moved {
  from = aws_iam_role_policy_attachment.backend_secrets_attachment
  to   = module.iam.aws_iam_role_policy_attachment.backend_secrets_attachment
}

moved {
  from = aws_iam_role_policy_attachment.backend_ecr_attachment
  to   = module.iam.aws_iam_role_policy_attachment.backend_ecr_attachment
}

moved {
  from = aws_iam_role_policy_attachment.frontend_ecr_attachment
  to   = module.iam.aws_iam_role_policy_attachment.frontend_ecr_attachment
}

moved {
  from = aws_iam_role_policy_attachment.backend_kms_attachment
  to   = module.iam.aws_iam_role_policy_attachment.backend_kms_attachment
}

moved {
  from = aws_iam_role_policy_attachment.backend_irsa_kms_attachment
  to   = module.iam.aws_iam_role_policy_attachment.backend_irsa_kms_attachment
}

moved {
  from = aws_iam_role_policy_attachment.database_secret_attachment
  to   = module.iam.aws_iam_role_policy_attachment.database_secret_attachment
}

moved {
  from = aws_iam_policy.ssm_core_custom
  to   = module.iam.aws_iam_policy.ssm_core_custom
}

moved {
  from = aws_iam_role_policy_attachment.frontend_ssm_custom
  to   = module.iam.aws_iam_role_policy_attachment.frontend_ssm_custom
}

moved {
  from = aws_iam_role_policy_attachment.backend_ssm_custom
  to   = module.iam.aws_iam_role_policy_attachment.backend_ssm_custom
}

moved {
  from = aws_iam_role_policy_attachment.database_ssm_custom
  to   = module.iam.aws_iam_role_policy_attachment.database_ssm_custom
}

moved {
  from = aws_iam_role.upload_logger_lambda_role
  to   = module.iam.aws_iam_role.upload_logger_lambda_role
}

moved {
  from = aws_iam_role.report_lambda_role
  to   = module.iam.aws_iam_role.report_lambda_role
}

moved {
  from = aws_iam_role.query_songs_lambda_role
  to   = module.iam.aws_iam_role.query_songs_lambda_role
}

moved {
  from = aws_iam_role_policy_attachment.upload_logger_basic_execution
  to   = module.iam.aws_iam_role_policy_attachment.upload_logger_basic_execution
}

moved {
  from = aws_iam_role_policy_attachment.upload_logger_vpc_access
  to   = module.iam.aws_iam_role_policy_attachment.upload_logger_vpc_access
}

moved {
  from = aws_iam_role_policy_attachment.report_basic_execution
  to   = module.iam.aws_iam_role_policy_attachment.report_basic_execution
}

moved {
  from = aws_iam_role_policy_attachment.report_vpc_access
  to   = module.iam.aws_iam_role_policy_attachment.report_vpc_access
}

moved {
  from = aws_iam_role_policy_attachment.query_songs_basic_execution
  to   = module.iam.aws_iam_role_policy_attachment.query_songs_basic_execution
}

moved {
  from = aws_iam_role_policy_attachment.query_songs_vpc_access
  to   = module.iam.aws_iam_role_policy_attachment.query_songs_vpc_access
}

moved {
  from = aws_iam_policy.upload_logger_lambda_policy
  to   = module.iam.aws_iam_policy.upload_logger_lambda_policy
}

moved {
  from = aws_iam_policy.report_lambda_policy
  to   = module.iam.aws_iam_policy.report_lambda_policy
}

moved {
  from = aws_iam_policy.query_songs_lambda_policy
  to   = module.iam.aws_iam_policy.query_songs_lambda_policy
}

moved {
  from = aws_iam_role_policy_attachment.upload_logger_custom_attachment
  to   = module.iam.aws_iam_role_policy_attachment.upload_logger_custom_attachment
}

moved {
  from = aws_iam_role_policy_attachment.report_lambda_attachment
  to   = module.iam.aws_iam_role_policy_attachment.report_lambda_attachment
}

moved {
  from = aws_iam_role_policy_attachment.query_songs_custom_attachment
  to   = module.iam.aws_iam_role_policy_attachment.query_songs_custom_attachment
}

moved {
  from = aws_iam_role.bedrock_agent_role
  to   = module.iam.aws_iam_role.bedrock_agent_role
}
