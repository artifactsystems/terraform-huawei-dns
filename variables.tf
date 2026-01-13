variable "create" {
  description = "Controls if DNS zone should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the DNS zone. Must end with a dot (e.g., 'example.local.')"
  type        = string
}

variable "region" {
  description = "HuaweiCloud region where the DNS zone will be created"
  type        = string
  default     = null
}

variable "zone_type" {
  description = "Type of DNS zone. Valid values are 'private' (default) or 'public'"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "public"], var.zone_type)
    error_message = "zone_type must be either 'private' or 'public'."
  }
}

variable "vpc_id" {
  description = "VPC ID to associate with the private DNS zone. Required for private zones, null for public zones"
  type        = string
  default     = null
}

variable "vpc_region" {
  description = "Region where the VPC is located. Optional for private zones"
  type        = string
  default     = null
}

################################################################################
# Zone Settings
################################################################################

variable "email" {
  description = "Email address of the administrator managing the zone"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the DNS zone"
  type        = string
  default     = null
}

variable "ttl" {
  description = "Time to live (TTL) of the zone in seconds"
  type        = number
  default     = 300

  validation {
    condition     = var.ttl >= 1 && var.ttl <= 2147483647
    error_message = "TTL must be between 1 and 2,147,483,647 seconds."
  }
}

variable "proxy_pattern" {
  description = "Recursive resolution proxy mode for private zones. Valid values are 'AUTHORITY' (default) or 'RECURSIVE'"
  type        = string
  default     = "AUTHORITY"

  validation {
    condition     = contains(["AUTHORITY", "RECURSIVE"], var.proxy_pattern)
    error_message = "proxy_pattern must be either 'AUTHORITY' or 'RECURSIVE'."
  }
}

variable "dnssec" {
  description = "DNSSEC status for public zones. Valid values are 'ENABLE' or 'DISABLE'. Only applicable for public zones"
  type        = string
  default     = null

  validation {
    condition     = var.dnssec == null || contains(["ENABLE", "DISABLE"], var.dnssec)
    error_message = "dnssec must be either 'ENABLE' or 'DISABLE' if specified."
  }
}

variable "status" {
  description = "Status of the DNS zone. Valid values are 'ENABLE' (default) or 'DISABLE'"
  type        = string
  default     = "ENABLE"

  validation {
    condition     = contains(["ENABLE", "DISABLE"], var.status)
    error_message = "status must be either 'ENABLE' or 'DISABLE'."
  }
}

variable "enterprise_project_id" {
  description = "Enterprise project ID"
  type        = string
  default     = null
}

################################################################################
# Recordset Settings
################################################################################

variable "recordsets" {
  description = "Map of DNS recordset objects. Supports all record types: A, AAAA, CNAME, MX, TXT, SRV, CAA, NS"
  type = map(object({
    name        = string
    type        = string
    records     = list(string)
    ttl         = optional(number)
    description = optional(string)
    status      = optional(string, "ENABLE")
    # Public zone özellikleri (ileride aktif hale getirilebilir)
    line_id     = optional(string)
    weight      = optional(number) # Valid range: 1-1000 (only for public zones)
    tags        = optional(map(string), {})
  }))
  default = {}
}

################################################################################
# Tags
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
