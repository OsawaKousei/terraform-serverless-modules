# CSR Web App サンプル

このサンプルは、`csr-web-app`モジュールを使用してReactやVueなどのクライアントサイドレンダリング(CSR)アプリケーションをAWSにデプロイする方法を示しています。

## 構成

このサンプルでは以下のAWSリソースが作成されます：

- S3バケット（静的ファイルホスティング用）
- CloudFrontディストリビューション（CDN）
- Origin Access Control (OAC)
- S3バケットポリシー

## 使い方

### 1. terraform.tfvarsファイルの作成

サンプルファイルをコピーして編集します：

```bash
cp terraform.tfvars.example terraform.tfvars
```

必要に応じて`terraform.tfvars`を編集してください：

```hcl
# 基本設定
bucket_name_prefix = "my-csr-web-app"
environment        = "dev"

# カスタムドメインを使用する場合
# use_custom_domain   = true
# domain_name         = "app.example.com"
# acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
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

### 5. ビルドしたファイルをS3にアップロード

```bash
# Reactアプリの例
aws s3 sync ./build s3://$(terraform output -raw s3_bucket_name)/ --delete

# Next.js (export)の例
aws s3 sync ./out s3://$(terraform output -raw s3_bucket_name)/ --delete

# Vueアプリの例
aws s3 sync ./dist s3://$(terraform output -raw s3_bucket_name)/ --delete
```

### 6. CloudFrontのキャッシュをクリア

```bash
aws cloudfront create-invalidation \
  --distribution-id $(terraform output -raw distribution_id) \
  --paths "/*"
```

### 7. アクセス

```bash
echo "https://$(terraform output -raw cloudfront_domain_name)"
```

## カスタマイズ

すべての設定は`terraform.tfvars`ファイルで管理されています。

### カスタムドメインの使用

カスタムドメインを使用する場合は、`terraform.tfvars`で以下を設定してください：

```hcl
use_custom_domain   = true
domain_name         = "app.example.com"
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
```

**注意点：**
1. ACM証明書はCloudFront用に**us-east-1リージョン**で発行する必要があります
2. Route 53やドメインレジストラでCNAMEレコードを設定してください：
   ```
   app.example.com -> d1234abcd5678.cloudfront.net
   ```

### リージョンの変更

```hcl
aws_region = "us-east-1"
```

### バケット名のカスタマイズ

```hcl
bucket_name_prefix = "my-custom-app"
```

### 利用可能な変数

すべての変数と説明は[variables.tf](variables.tf)を参照してください。

主な変数:
- `bucket_name_prefix`: S3バケット名のプレフィックス（アカウントIDが自動付加されます）
- `use_custom_domain`: カスタムドメインを使用するかどうか
- `domain_name`: カスタムドメイン名
- `acm_certificate_arn`: ACM証明書ARN（us-east-1リージョン）
- `environment`: 環境名（タグ付けに使用）

## クリーンアップ

```bash
# S3バケット内のファイルを削除
aws s3 rm s3://$(terraform output -raw s3_bucket_name)/ --recursive

# Terraformリソースを削除
terraform destroy
```

## 注意事項

- S3バケット名はグローバルで一意である必要があります
- ACM証明書はCloudFront用にus-east-1リージョンで発行する必要があります
- SPAのルーティング対応のため、403/404エラーは自動的に`index.html`にリダイレクトされます
