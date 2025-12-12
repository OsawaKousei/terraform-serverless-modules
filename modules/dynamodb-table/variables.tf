variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Primary Partition Key name (e.g., 'PK')"
  type        = string
  default     = "PK"
}

variable "range_key" {
  description = "Primary Sort Key name (e.g., 'SK')"
  type        = string
  default     = "SK"
}

variable "attributes" {
  description = "List of attributes needed for Keys and GSIs. Format: [{name='PK', type='S'}, ...]"
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  description = "List of GSIs configurations"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = string
    non_key_attributes = optional(list(string))
    read_capacity      = optional(number)
    write_capacity     = optional(number)
  }))
  default = []
}

variable "ttl_attribute" {
  description = "Attribute name for TTL (Time To Live). Leave empty to disable."
  type        = string
  default     = ""
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "pitr_enabled" {
  description = "Enable Point-In-Time Recovery (Costs apply)"
  type        = bool
  default     = false # デフォルトはOFFにしておき、本番だけONにするなど
}

variable "read_capacity" {
  description = "Read capacity units (RCU). Only used when billing_mode is PROVISIONED."
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units (WCU). Only used when billing_mode is PROVISIONED."
  type        = number
  default     = 5
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
