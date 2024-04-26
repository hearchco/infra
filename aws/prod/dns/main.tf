terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/prod/dns/terraform.tfstate"
    encrypt        = "true"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "eu-central-1"
}

module "hearchco_route53" {
  source      = "../../modules/dns/route53"
  domain_name = var.domain_name

  additional_records = [
    // email
    {
      name    = "",
      type    = "MX",
      ttl     = 86400,
      records = ["0 mx.tmina.org"]
    },
    {
      name    = "dkim._domainkey",
      type    = "TXT",
      ttl     = 86400,
      records = ["v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1HAbtoPRqtjd7nn+1T98CgoVHRnCYD73keFXBNVwIRM+lC1mCcI25M3H3GmDrUvAMc+xGsU6LwHFMf/KL6FF+Xl9o3kKtrlQgjEXR4V0hl2330LMw+x1+eHJs+5lzxOOGw/eqin8NAGLF/mT2g6Ad8cIesOSpFDrx2XR+WOTMciAv3V3bJK7nDa", "cH3GI12Gx42NlNOFVRAqETZVfKbsyeM8dxvQDVo4vBay/eo1xC4cv0fKx2Jb+5sOvGLHb2bDONDCsrT+IJkxNvVqAitlatbWoMgIL0Pz6GvXvrWjKMJVO1PA9CJWheB9UawV+xn50vjMsobZ2c+iyrIN7UuDI6wIDAQAB"]
    },
    {
      name    = "_dmarc",
      type    = "TXT",
      ttl     = 86400,
      records = ["v=DMARC1; p=quarantine; rua=mailto:report@hearch.co"]
    },
    {
      name    = "",
      type    = "TXT",
      ttl     = 86400,
      records = ["v=spf1 mx a -all"]
    },
    // github
    {
      name    = "_github-challenge-hearchco-org",
      type    = "TXT",
      ttl     = 60,
      records = ["b71364f49f"]
    },
    {
      name    = "_github-pages-challenge-hearchco",
      type    = "TXT",
      ttl     = 60,
      records = ["390ffbc03eb0af048b8fbd64c099da"]
    },
    // dev
    {
      name = "dev",
      type = "NS",
      ttl  = 86400,
      records = [
        "ns-1882.awsdns-43.co.uk",
        "ns-1009.awsdns-62.net",
        "ns-1244.awsdns-27.org",
        "ns-182.awsdns-22.com"
      ]
    }
  ]
}
