module "gateway" {
    source         = "./modules/gateway"
    region         = var.region
    account_id     = var.account_id
    sqs_queue_name = module.sqs.sqs_queue_name
}
