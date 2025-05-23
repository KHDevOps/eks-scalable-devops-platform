module "iam" {
  source = "../../modules/iam"

  cluster_name = local.cluster_name

  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name

}