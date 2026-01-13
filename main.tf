locals {
  create_zone = var.create
  zone_type   = coalesce(var.zone_type, "private")
  is_private  = local.zone_type == "private"
  is_public   = local.zone_type == "public"
}

################################################################################
# DNS Zone
################################################################################

resource "huaweicloud_dns_zone" "this" {
  count = local.create_zone ? 1 : 0

  region = var.region

  name                  = var.name
  zone_type             = local.zone_type
  email                 = var.email
  description           = var.description
  ttl                   = var.ttl
  status                = var.status
  enterprise_project_id = var.enterprise_project_id

  # Private zone için router bloğu (VPC ilişkilendirmesi)
  dynamic "router" {
    for_each = local.is_private && var.vpc_id != null ? [1] : []
    content {
      router_id     = var.vpc_id
      router_region = var.vpc_region
    }
  }

  # Private zone için proxy_pattern
  proxy_pattern = local.is_private ? var.proxy_pattern : null

  # Public zone için DNSSEC (ileride aktif hale getirilebilir)
  dnssec = local.is_public && var.dnssec != null ? var.dnssec : null

  tags = merge(
    { "Name" = var.name },
    var.tags,
  )

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

################################################################################
# DNS Recordsets
################################################################################

resource "huaweicloud_dns_recordset" "this" {
  for_each = local.create_zone ? var.recordsets : {}

  region = var.region

  zone_id     = huaweicloud_dns_zone.this[0].id
  name        = each.value.name
  type        = each.value.type
  records     = each.value.records
  ttl         = try(each.value.ttl, var.ttl)
  description = try(each.value.description, null)
  status      = try(each.value.status, "ENABLE")

  line_id = local.is_public && try(each.value.line_id, null) != null ? each.value.line_id : null
  weight = local.is_public && try(each.value.weight, null) != null ? (
    try(each.value.weight, null) >= 1 && try(each.value.weight, null) <= 1000 ? each.value.weight : null
  ) : null

  tags = merge(
    { "Name" = each.value.name },
    var.tags,
    try(each.value.tags, {}),
  )

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}
