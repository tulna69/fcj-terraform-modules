terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0, < 2.0.0"
}

###################################################################
# -- TODO: define your LOCALS            
###################################################################
locals {
  static_website_dir_name = "static-website"
}
###################################################################
# -- TODO: define your MODULE            
###################################################################
module "template_files" {
  # Normal uploading with fileset function has not map filename suffixes
  # with correct content-type => use this module instead
  # References:
  # - https://stackoverflow.com/questions/68159729/s3-website-downloads-files-instead-of-displaying-pages
  # - https://stackoverflow.com/questions/18296875/amazon-s3-downloads-index-html-instead-of-serving
  source = "hashicorp/dir/template"
  base_dir = "${path.module}/../../${static_website_dir_name}"
}

###################################################################
# -- TODO: define your DATA
###################################################################
data "aws_iam_policy_document" "allow_public_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

###################################################################
# -- TODO: define your RESOURCE
###################################################################

#-----------------------------------
# -- TODO: define S3
#-----------------------------------
resource "aws_s3_bucket" "this" {
    bucket =  var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "this" {
    bucket = aws_s3_bucket.this.id

    index_document {
        suffix = "index.html"
    }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.use_cloudfront ? 0 : 1
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

resource "aws_s3_object" "this" {
    bucket = aws_s3_bucket.this.id

    for_each = module.template_files.files
    source      = each.value.source_path
    content_type = each.value.content_type
    key    = split("${static_website_dir_name}/", each.value.source_path)[1]
}