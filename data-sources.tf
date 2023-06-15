# https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/data-sources/device
data "tailscale_devices" "servers" { name_prefix = "server-" }
data "tailscale_devices" "dns"     { name_prefix = var.TAILSCALE_DNS_SRV }
data "tailscale_devices" "devices" { }