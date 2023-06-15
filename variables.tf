variable "TAILSCALE_TAILNET" {
  description = "Tailscale's target tailnet"
  type = string
}

# https://login.tailscale.com/admin/settings/keys
variable "TAILSCALE_API_KEY" {
  description = "Temp API key for 90 days"
  type = string
}

variable "TAILSCALE_DNS_SRV" {
  description = "The name of the custom DNS server."
  type = string
}

variable "TAILSCALE_ACL" {
  description = "Check out the ACL tab in Tailscale console for more. Do not specify type."
}