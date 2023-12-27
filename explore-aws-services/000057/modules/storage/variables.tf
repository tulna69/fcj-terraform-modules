variable "bucket_name" {
    type = string
    description = "The name of the bucket"
}

variable "use_cloudfront" {
    type = bool
    description = "Using CloudFront with S3"
}