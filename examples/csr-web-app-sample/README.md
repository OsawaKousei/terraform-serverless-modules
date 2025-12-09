# CSR Web App サンプル

このサンプルは、`csr-web-app`モジュールを使用してReactやVueなどのクライアントサイドレンダリング(CSR)アプリケーションをAWSにデプロイする方法を示しています。

## 構成

このサンプルでは以下のAWSリソースが作成されます：

- S3バケット（静的ファイルホスティング用）
- CloudFrontディストリビューション（CDN）
- Origin Access Control (OAC)
- S3バケットポリシー

## 使い方

### 1. 初期化

```bash
terraform init
```

### 2. プランの確認

```bash
terraform plan
```

### 3. デプロイ

```bash
terraform apply
```

### 4. ビルドしたファイルをS3にアップロード

```bash
# Reactアプリの例
aws s3 sync ./build s3://$(terraform output -raw s3_bucket_name)/ --delete

# Next.js (export)の例
aws s3 sync ./out s3://$(terraform output -raw s3_bucket_name)/ --delete

# Vueアプリの例
aws s3 sync ./dist s3://$(terraform output -raw s3_bucket_name)/ --delete
```

### 5. CloudFrontのキャッシュをクリア

```bash
aws cloudfront create-invalidation \
  --distribution-id $(terraform output -raw distribution_id) \
  --paths "/*"
```

### 6. アクセス

```bash
echo "https://$(terraform output -raw cloudfront_domain_name)"
```

## カスタムドメインの使用

カスタムドメインを使用する場合は、`main.tf`で以下の設定を有効にしてください：

1. `domain_name`にカスタムドメイン名を指定
2. `acm_certificate_arn`にus-east-1リージョンで発行したACM証明書のARNを指定
3. Route 53やドメインレジストラでCNAMEレコードを設定

```hcl
module "csr_web_app" {
  source = "../../csr-web-app"

  bucket_name          = "my-csr-web-app-${data.aws_caller_identity.current.account_id}"
  domain_name          = "app.example.com"
  acm_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  tags = {
    Environment = "dev"
    Project     = "csr-web-app-sample"
  }
}
```

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
