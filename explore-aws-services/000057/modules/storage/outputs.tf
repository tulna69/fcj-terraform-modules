output "website_endpoint" {
    value = aws_s3_bucket_website_configuration.this.website_endpoint
    description = "The endpoint of the website"
}
