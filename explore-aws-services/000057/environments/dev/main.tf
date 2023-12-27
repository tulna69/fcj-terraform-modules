provider "aws" {
    region = "us-east-1"
}

module "static_website" {
    source = "../../modules/storage"

    bucket_name = "aws-first-cloud-journey-69"
    use_cloudfront = true
}