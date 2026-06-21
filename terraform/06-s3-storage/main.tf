resource "aws_s3_bucket" "telco_documents" {
  bucket = "${var.project_name}-documents-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-documents"
    Environment = "learning"
    Purpose     = "Customer documents"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_public_access_block" "telco_documents_block" {
  bucket = aws_s3_bucket.telco_documents.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "telco_documents_versioning" {
  bucket = aws_s3_bucket.telco_documents.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "telco_documents_encryption" {
  bucket = aws_s3_bucket.telco_documents.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "telco_documents_lifecycle" {
  bucket = aws_s3_bucket.telco_documents.id

  rule {
    id     = "archive-old-documents"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}
