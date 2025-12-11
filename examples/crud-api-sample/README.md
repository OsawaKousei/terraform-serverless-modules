# CRUD API サンプル

このサンプルは、`crud-api`モジュールを使用してデータベース連携のCRUD APIをAWSにデプロイする方法を示しています。

## 構成

このサンプルでは以下のAWSリソースが作成されます：

- API Gateway (HTTP API)
- Lambda関数（コンテナイメージ）
- DynamoDBテーブル
- IAMロールとポリシー（Lambda実行用、DynamoDBアクセス用）

## 前提条件

このサンプルを実行する前に、以下が必要です：

1. **ECRリポジトリとコンテナイメージ**
   - Lambda関数用のコンテナイメージをECRにプッシュしておく必要があります
   - イメージURIの例: `123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-app:latest`

2. **Lambda関数の環境変数**
   - Lambda関数には自動的に`DYNAMODB_TABLE_NAME`環境変数が設定されます
   - アプリケーションコードでこの環境変数を使用してDynamoDBテーブルにアクセスできます

## 使い方

### 1. terraform.tfvarsファイルの作成

```bash
cat > terraform.tfvars <<EOF
image_uri = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-app:latest"
EOF
```

### 2. 初期化

```bash
terraform init
```

### 3. プランの確認

```bash
terraform plan
```

### 4. デプロイ

```bash
terraform apply
```

### 5. APIエンドポイントの確認

```bash
echo "API Endpoint: $(terraform output -raw api_endpoint)"
```

### 6. APIのテスト

```bash
# GETリクエストの例
curl $(terraform output -raw api_endpoint)

# POSTリクエストの例
curl -X POST $(terraform output -raw api_endpoint) \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'
```

### 7. DynamoDBテーブルの確認

```bash
# テーブル名の確認
terraform output -raw dynamodb_table_name

# テーブルの内容をスキャン
aws dynamodb scan --table-name $(terraform output -raw dynamodb_table_name)
```

## カスタマイズ

### DynamoDBテーブル名を指定する

`main.tf`で`dynamodb_table_name`を設定します：

```hcl
module "crud_api" {
  source = "../../modules/crud-api"

  name_prefix         = "my-crud-api"
  image_uri           = var.image_uri
  dynamodb_table_name = "my-custom-table-name"

  tags = {
    Environment = "dev"
  }
}
```

### DynamoDBの課金モードを変更する

デフォルトは`PAY_PER_REQUEST`（オンデマンド）ですが、プロビジョニングモードに変更できます：

```hcl
module "crud_api" {
  source = "../../modules/crud-api"

  name_prefix           = "my-crud-api"
  image_uri             = var.image_uri
  dynamodb_billing_mode = "PROVISIONED"

  tags = {
    Environment = "dev"
  }
}
```

## Lambda関数の実装例

Lambda関数では、環境変数`DYNAMODB_TABLE_NAME`を使用してDynamoDBテーブルにアクセスできます。

### Python例

```python
import os
import json
import boto3

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # DynamoDBへの書き込み例
    table.put_item(
        Item={
            'id': 'example-id',
            'data': 'example-data'
        }
    )
    
    # DynamoDBからの読み取り例
    response = table.get_item(Key={'id': 'example-id'})
    
    return {
        'statusCode': 200,
        'body': json.dumps(response.get('Item', {}))
    }
```

### Node.js例

```javascript
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand, GetCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);
const tableName = process.env.DYNAMODB_TABLE_NAME;

exports.handler = async (event) => {
    // DynamoDBへの書き込み例
    await docClient.send(new PutCommand({
        TableName: tableName,
        Item: {
            id: 'example-id',
            data: 'example-data'
        }
    }));
    
    // DynamoDBからの読み取り例
    const response = await docClient.send(new GetCommand({
        TableName: tableName,
        Key: { id: 'example-id' }
    }));
    
    return {
        statusCode: 200,
        body: JSON.stringify(response.Item || {})
    };
};
```

## クリーンアップ

```bash
terraform destroy
```

## 注意事項

- Lambda関数には自動的にDynamoDBへの読み書き権限が付与されます
- DynamoDBテーブルのパーティションキーは`id`（文字列型）として作成されます
- 必要に応じてソートキーやGSI（グローバルセカンダリインデックス）を追加する場合は、モジュールをカスタマイズしてください
- API Gatewayは`$default`ルートでLambdaと統合されているため、すべてのHTTPメソッドとパスがLambdaに転送されます

## トラブルシューティング

### Lambda関数のログを確認

```bash
aws logs tail /aws/lambda/my-serverless-api-function --follow
```

### DynamoDBテーブルの確認

```bash
# テーブルの詳細を確認
aws dynamodb describe-table --table-name $(terraform output -raw dynamodb_table_name)

# テーブルのアイテムを確認
aws dynamodb scan --table-name $(terraform output -raw dynamodb_table_name)
```
