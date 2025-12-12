resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode

  # Primary Keys
  hash_key  = var.hash_key
  range_key = var.range_key

  # ---------------------------------------------------------
  # Capacity (Only relevant for PROVISIONED)
  # ---------------------------------------------------------
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  # ---------------------------------------------------------
  # Attribute Definitions
  # 【重要】ここには PK, SK, GSIのキー に使用する属性"だけ"を定義します。
  # それ以外のデータ属性（JSONの中身など）を定義するとデプロイエラーになります。
  # ---------------------------------------------------------
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # ---------------------------------------------------------
  # Global Secondary Indexes
  # ---------------------------------------------------------
  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type

      # GSIを使う場合、射影する属性を指定する場合がある
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)

      read_capacity  = var.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "read_capacity", 5) : null
      write_capacity = var.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "write_capacity", 5) : null
    }
  }

  # ---------------------------------------------------------
  # Security & Reliability Settings
  # ---------------------------------------------------------
  dynamic "ttl" {
    for_each = var.ttl_attribute != "" ? [1] : []
    content {
      attribute_name = var.ttl_attribute
      enabled        = true
    }
  }

  point_in_time_recovery {
    enabled = var.pitr_enabled
  }

  server_side_encryption {
    enabled = true
    # 必要に応じてKMSキーを指定可能にする場合:
    # kms_key_arn = var.kms_key_arn 
  }

  deletion_protection_enabled = var.deletion_protection_enabled

  tags = var.tags

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
      # 注意: GSIごとのキャパシティもAutoscaling対象にする場合、
      # Terraformの構文制限によりここでの記述が難しいため、
      # 運用時は「GSIキャパシティの変更差分」を許容するか、
      # 定義ファイルをAutoscaling後の値に合わせる運用が必要になります。
    ]
  }
}
