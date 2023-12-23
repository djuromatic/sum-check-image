### AWS ###
export CDK_PROFILE=jelly-dev # aws sso profile
export REGION=eu-central-1
export ACCOUNT="430792124313"

### CDK APPLICATION ###
export VPC_ID="vpc-01ebd27c5710af92e"
export SSH_KEY_NAME="djuro-ssh"

### DNS ###
export HOSTED_ZONE_NAME="dev.mvpworkshop.co"  # DNS Zone name
export HOSTED_ZONE_ID="Z04492101LNYUR3GKQKZX" # DNS Zone ID

export CDK_DEBUG=true
# cdk bootstrap --profile $CDK_PROFILE
cdk destroy --all --profile $CDK_PROFILE

# cdk destroy --profile $AWS_PROFILE
