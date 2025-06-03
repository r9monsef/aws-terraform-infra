#!/bin/bash

# Set AWS region
AWS_REGION="us-east-1"

# Define bucket names and DynamoDB table names
PROD_BUCKET="reza-prod-terraform-state"
STAGE_BUCKET="reza-stage-terraform-state"
PROD_TABLE="terraform-state-lock-prod"
STAGE_TABLE="terraform-state-lock-stage"

echo "Creating S3 buckets and DynamoDB tables for prod and stage environments..."

# Function to create S3 bucket
create_s3_bucket() {
  local BUCKET_NAME=$1
  echo "Creating S3 bucket: $BUCKET_NAME"
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION" 

  # Enable encryption
  aws s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --server-side-encryption-configuration '{
      "Rules": [
        {
          "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "AES256"
          }
        }
      ]
    }'

  # Enable versioning
  aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled
}

# Function to create DynamoDB table
create_dynamodb_table() {
  local TABLE_NAME=$1
  echo "Creating DynamoDB table: $TABLE_NAME"
  aws dynamodb create-table \
    --table-name "$TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$AWS_REGION" || echo "Table $TABLE_NAME may already exist."
}

# Create buckets
create_s3_bucket "$PROD_BUCKET"
create_s3_bucket "$STAGE_BUCKET"

# Create DynamoDB tables
create_dynamodb_table "$PROD_TABLE"
create_dynamodb_table "$STAGE_TABLE"

echo "✅ Setup completed!"
