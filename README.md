# HuaweiCloud DNS Terraform Module

Terraform module which creates DNS resources on HuaweiCloud.

## Features

- ✅ **Private DNS Zones**: Create private hosted zones for internal DNS management
- ✅ **DNS Recordsets**: Support for A, AAAA, CNAME, MX, TXT, SRV, CAA, NS record types
- ✅ **VPC Integration**: Associate private zones with VPCs
- ✅ **Flexible Configuration**: Customizable TTL, descriptions, and tags
- ✅ **Extensible Design**: Ready for future features (public zones, PTR records, zone associations)

## Usage

### Basic Example - Private Zone with A Records

```hcl
module "dns" {
  source = "./terraform-huawei-dns"

  name   = "internal.local."
  vpc_id = module.vpc.vpc_id
  email  = "admin@example.com"

  recordsets = {
    "sql-primary" = {
      name        = "sql-primary.internal.local."
      type        = "A"
      records     = ["10.0.1.10"]
      ttl         = 300
      description = "Primary SQL Server"
    }
    "sql-secondary" = {
      name    = "sql-secondary.internal.local."
      type    = "A"
      records = ["10.0.1.11"]
      ttl     = 300
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Example with Multiple Record Types

```hcl
module "dns" {
  source = "./terraform-huawei-dns"

  name   = "example.local."
  vpc_id = module.vpc.vpc_id
  email  = "admin@example.com"

  recordsets = {
    "web" = {
      name    = "web.example.local."
      type    = "A"
      records = ["10.0.1.20"]
      ttl     = 300
    }
    "api" = {
      name    = "api.example.local."
      type    = "CNAME"
      records = ["web.example.local."]
      ttl     = 300
    }
    "mail" = {
      name    = "example.local."
      type    = "MX"
      records = ["10 mail.example.local."]
      ttl     = 300
    }
  }
}
```

### Example with Custom TTL and Proxy Pattern

```hcl
module "dns" {
  source = "./terraform-huawei-dns"

  name          = "internal.local."
  vpc_id        = module.vpc.vpc_id
  vpc_region    = "tr-west-1"
  email         = "admin@example.com"
  description   = "Internal DNS zone for production"
  ttl           = 600
  proxy_pattern = "RECURSIVE"

  recordsets = {
    "db" = {
      name    = "db.internal.local."
      type    = "A"
      records = ["10.0.1.100"]
      ttl     = 300
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| huaweicloud | >= 1.79.0 |

## Providers

| Name | Version |
|------|---------|
| huaweicloud | >= 1.79.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Controls if DNS zone should be created | `bool` | `true` | no |
| name | Name of the DNS zone. Must end with a dot (e.g., 'example.local.') | `string` | n/a | yes |
| region | HuaweiCloud region where the DNS zone will be created | `string` | `null` | no |
| zone_type | Type of DNS zone. Valid values are 'private' (default) or 'public' | `string` | `"private"` | no |
| vpc_id | VPC ID to associate with the private DNS zone. Required for private zones, null for public zones | `string` | `null` | no |
| vpc_region | Region where the VPC is located. Optional for private zones | `string` | `null` | no |
| email | Email address of the administrator managing the zone | `string` | `null` | no |
| description | Description of the DNS zone | `string` | `null` | no |
| ttl | Time to live (TTL) of the zone in seconds | `number` | `300` | no |
| proxy_pattern | Recursive resolution proxy mode for private zones. Valid values are 'AUTHORITY' (default) or 'RECURSIVE' | `string` | `"AUTHORITY"` | no |
| dnssec | DNSSEC status for public zones. Valid values are 'ENABLE' or 'DISABLE'. Only applicable for public zones | `string` | `null` | no |
| status | Status of the DNS zone. Valid values are 'ENABLE' (default) or 'DISABLE' | `string` | `"ENABLE"` | no |
| enterprise_project_id | Enterprise project ID | `string` | `null` | no |
| recordsets | Map of DNS recordset objects. Supports all record types: A, AAAA, CNAME, MX, TXT, SRV, CAA, NS | `map(object)` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

### Recordset Object

Each recordset in the `recordsets` map supports the following attributes:

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| name | Name of the recordset. Must end with zone name (e.g., 'sql.example.local.') | `string` | yes |
| type | Type of DNS record. Valid values: A, AAAA, CNAME, MX, TXT, SRV, CAA, NS | `string` | yes |
| records | List of record values | `list(string)` | yes |
| ttl | Time to live in seconds. If not specified, uses zone TTL | `number` | no |
| description | Description of the recordset | `string` | no |
| status | Status of the recordset. Valid values: 'ENABLE' (default) or 'DISABLE' | `string` | no |
| line_id | Resolution line ID (public zones only, future feature) | `string` | no |
| weight | Weight for weighted routing (public zones only, future feature) | `number` | no |
| tags | Additional tags for the recordset | `map(string)` | no |

## Outputs

| Name | Description |
|------|-------------|
| zone_id | The ID of the DNS zone |
| zone_name | The name of the DNS zone |
| zone_type | The type of the DNS zone (private or public) |
| zone_status | The status of the DNS zone |
| zone_dnssec_infos | DNSSEC information for public zones |
| recordset_ids | Map of recordset IDs keyed by recordset key |
| recordset_details | Map of recordset details keyed by recordset key |
| recordset_names | Map of recordset names keyed by recordset key |
| recordset_types | Map of recordset types keyed by recordset key |
| recordset_records | Map of recordset records keyed by recordset key |

## Notes

- Zone name must end with a dot (.) (e.g., `example.local.`)
- Recordset names must end with the zone name (e.g., `sql.example.local.`)
- VPC ID is required for private zones
- VPC association is done automatically when creating a private zone
- The module is designed to be extensible for future features:
  - Public zone support
  - PTR records
  - Zone associations (multiple VPCs)
  - DNS resolver rules
  - DNS endpoints

## Future Features

The module is designed with extensibility in mind. Future versions may include:

1. **Public Zone Support**
   - Public DNS zones with DNSSEC
   - Line groups and custom lines
   - Weighted routing

2. **PTR Records**
   - Reverse DNS for EIPs
   - PTR record management

3. **Zone Associations**
   - Multiple VPC associations for private zones
   - Zone authorization and retrieval

4. **DNS Resolver**
   - Resolver rules and associations
   - Resolver access logs

5. **DNS Endpoints**
   - DNS endpoint and endpoint assignments

## License

Apache 2.0

## Contributing

Contributions are welcome! Please read the contributing guidelines first.
