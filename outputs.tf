################################################################################
# DNS Zone Outputs
################################################################################

output "zone_id" {
  description = "The ID of the DNS zone"
  value       = try(huaweicloud_dns_zone.this[0].id, null)
}

output "zone_name" {
  description = "The name of the DNS zone"
  value       = try(huaweicloud_dns_zone.this[0].name, null)
}

output "zone_type" {
  description = "The type of the DNS zone (private or public)"
  value       = try(huaweicloud_dns_zone.this[0].zone_type, null)
}

output "zone_status" {
  description = "The status of the DNS zone"
  value       = try(huaweicloud_dns_zone.this[0].status, null)
}

output "zone_created_at" {
  description = "The creation time of the DNS zone"
  value       = try(huaweicloud_dns_zone.this[0].created_at, null)
}

output "zone_updated_at" {
  description = "The update time of the DNS zone"
  value       = try(huaweicloud_dns_zone.this[0].updated_at, null)
}

output "zone_dnssec_infos" {
  description = "DNSSEC information for public zones"
  value       = try(huaweicloud_dns_zone.this[0].dnssec_infos, null)
}

################################################################################
# DNS Recordset Outputs
################################################################################

output "recordset_ids" {
  description = "Map of recordset IDs keyed by recordset key"
  value       = { for k, v in huaweicloud_dns_recordset.this : k => v.id }
}

output "recordset_details" {
  description = "Map of recordset details keyed by recordset key"
  value = {
    for k, v in huaweicloud_dns_recordset.this : k => {
      id          = v.id
      name        = v.name
      type        = v.type
      records     = v.records
      ttl         = v.ttl
      description = v.description
      status      = v.status
      line_id     = try(v.line_id, null)
      weight      = try(v.weight, null)
      zone_name   = v.zone_name
      zone_type   = v.zone_type
    }
  }
}

output "recordset_names" {
  description = "Map of recordset names keyed by recordset key"
  value       = { for k, v in huaweicloud_dns_recordset.this : k => v.name }
}

output "recordset_types" {
  description = "Map of recordset types keyed by recordset key"
  value       = { for k, v in huaweicloud_dns_recordset.this : k => v.type }
}

output "recordset_records" {
  description = "Map of recordset records keyed by recordset key"
  value       = { for k, v in huaweicloud_dns_recordset.this : k => v.records }
}
