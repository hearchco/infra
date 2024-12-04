include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${path_relative_from_include()}/../..//stacks/dns"
}

locals {
  aws_profile = include.root.locals.aws_profile
  environment = include.root.locals.environment
  domain_name = include.root.locals.domain_name

  dnssec = true
  records = [
    // Email
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
    // Github
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
    // Updown
    {
      name    = "status",
      type    = "CNAME",
      ttl     = 86400,
      records = ["page.updown.io"]
    },
    {
      name    = "_updown.status",
      type    = "TXT",
      ttl     = 60,
      records = ["updown-page=p/az8oo"]
    }
  ]
}

inputs = {
  aws_profile = local.aws_profile
  domain_name = local.domain_name
  records     = local.records
  dnssec      = local.dnssec
}
