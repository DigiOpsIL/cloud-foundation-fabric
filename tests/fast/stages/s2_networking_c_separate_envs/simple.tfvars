automation = {
  outputs_bucket = "test"
}
billing_account = {
  id = "000000-111111-222222"
}
custom_roles = {
  project_iam_viewer            = "organizations/123456789012/roles/bar"
  service_project_network_admin = "organizations/123456789012/roles/foo"
}
dns = {
  dev_resolvers  = ["10.10.10.10"]
  prod_resolvers = ["10.20.10.10"]
}
environments = {
  dev = {
    is_default = false
    name       = "Development"
    tag_name   = "development"
  }
  prod = {
    is_default = true
    name       = "Production"
    tag_name   = "production"
  }
}
essential_contacts = "gcp-network-admins@fast.example.com"
folder_ids = {
  networking      = "folders/12345"
  networking-dev  = null
  networking-prod = null
}
groups = {
  gcp-network-admins = "gcp-vpc-network-admins"
}
service_accounts = {
  data-platform-dev    = "string"
  data-platform-prod   = "string"
  gke-dev              = "string"
  gke-prod             = "string"
  project-factory      = "string"
  project-factory-dev  = "string"
  project-factory-prod = "string"
}
organization = {
  domain      = "fast.example.com"
  id          = 123456789012
  customer_id = "C00000000"
}
prefix = "fast2"
tag_values = {
  "environment/development" = "tagValues/12345"
  "environment/production"  = "tagValues/12346"
}
vpc_configs = {
  dev = {
    cloudnat = {
      enable = true
    }
  }
  prod = {
    cloudnat = {
      enable = true
    }
  }
}
vpn_onprem_dev_primary_config = {
  peer_external_gateways = {
    default = {
      redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
      interfaces      = ["8.8.8.8"]
    }
  }
  router_config = {
    asn = 65501
    custom_advertise = {
      all_subnets = false
      ip_ranges = {
        "10.1.0.0/16"     = "gcp"
        "35.199.192.0/19" = "gcp-dns"
        "199.36.153.4/30" = "gcp-restricted"
      }
    }
  }
  tunnels = {
    "0" = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 65500
      }
      bgp_session_range     = "169.254.1.2/30"
      shared_secret         = "foo"
      vpn_gateway_interface = 0
    }
    "1" = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_session_range     = "169.254.2.2/30"
      shared_secret         = "foo"
      vpn_gateway_interface = 1
    }
  }
}
vpn_onprem_prod_primary_config = {
  peer_external_gateways = {
    default = {
      redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
      interfaces      = ["8.8.4.4"]
    }
  }
  router_config = {
    asn = 65501
    custom_advertise = {
      all_subnets = false
      ip_ranges = {
        "10.1.0.0/16"     = "gcp"
        "35.199.192.0/19" = "gcp-dns"
        "199.36.153.4/30" = "gcp-restricted"
      }
    }
  }
  tunnels = {
    "0" = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 65500
      }
      bgp_session_range     = "169.254.3.2/30"
      shared_secret         = "foo"
      vpn_gateway_interface = 0
    }
    "1" = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_session_range     = "169.254.4.2/30"
      shared_secret         = "foo"
      vpn_gateway_interface = 1
    }
  }
}
