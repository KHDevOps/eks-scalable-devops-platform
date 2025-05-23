output "eks_cluster_sg_id" {
  description = "Security group ID for the EKS cluster"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_sg_id" {
  description = "Security group ID for the EKS nodes"
  value       = aws_security_group.eks_nodes.id
}

output "lb_sg_id" {
  description = "Load balancer Security group ID"
  value       = aws_security_group.lb_sg.id
}