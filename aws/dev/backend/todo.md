# Infra

## Regional

1. (I) S3 bucket to store zipped binary
2. (I) Zip and hash binary, upload it to S3
3. (I) Lambdas from S3 bucket
4. (I) API Gateway for lambda

## Global

1. (I) Route53 domain switch
2. (I) ACM configured
3. (I) Cloudfront CNAME in Route53 pointing to all API Gateways and Latency balancing (instead of GEO) - this might be Route53 setup also
4. (I) Cloudfront cache should be low and be different for query params!

# CD

1. (B) CD that on tag uploads zipped file to versioned S3
2. (I) Lambda trigger when bin.zip changes to update all lambdas to use new file
