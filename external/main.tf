module "cloudflare" {
  source                = "./modules/cloudflare"
  cloudflare_account_id = var.cloudflare_account_id
  cloudflare_email      = var.cloudflare_email
  cloudflare_api_key    = var.cloudflare_api_key
}

module "ntfy" {
  source = "./modules/ntfy"
  auth   = var.ntfy
}

module "extra_secrets" {
  source = "./modules/extra-secrets"
  data   = var.extra_secrets
}

resource "kubernetes_secret" "renovate_secret" {
  metadata {
    name      = "renovate-secret"
    namespace = "renovate"

    annotations = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    RENOVATE_TOKEN = var.renovate_token
  }

}
