provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "shiv-terraform-website"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

locals {
  files = fileset("myfiles", "*")
}

resource "aws_s3_bucket_object" "all_files" {
  for_each = toset(local.files)
  bucket   = aws_s3_bucket.website_bucket.id
  key      = each.value
  source   = "myfiles/${each.value}"
  acl      = "public-read"
}
