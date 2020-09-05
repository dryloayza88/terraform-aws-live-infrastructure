#backend.hcl
bucket          = "terraform-up-and-running-state-diego"
region          = "us-east-1"
dynamodb_table  = "terraform-up-and-running-locks"
encrypt         = true