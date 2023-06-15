provider "docker" {}

# https://registry.terraform.io/providers/tailscale/tailscale/latest/docs
provider "tailscale" {
  api_key = var.TAILSCALE_API_KEY
  tailnet = var.TAILSCALE_TAILNET
}
