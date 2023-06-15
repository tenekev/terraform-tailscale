terraform {
  required_providers {
    # https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    # https://github.com/tailscale/terraform-provider-tailscale
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.13.7"
    }
  }
}

#
# Disabling Magic DNS
# https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources/dns_preferences
  resource "tailscale_dns_preferences" "preferences" {
    magic_dns = false
  }

#
# Setting custom DNS server IP address
# https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources/dns_nameservers
  resource "tailscale_dns_nameservers" "nameservers" {
    nameservers = [
      data.tailscale_devices.dns.devices[0].addresses[0]
    ]
  }

#
# Setting ACL Rules
# https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources/acl
  resource "tailscale_acl" "default_acl" {
    acl = jsonencode(var.TAILSCALE_ACL)
  }

#
# Disabling key expiry on servers
# https://registry.terraform.io/providers/davidsbond/tailscale/latest/docs/resources/device_key
  resource "tailscale_device_key" "server" {
    for_each = {
      for index, device in data.tailscale_devices.servers.devices: device.name => device
    }

    device_id           = each.value.id
    key_expiry_disabled = true
  }

#
# Tagging devices based on naming convention
# https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources/device_tags
  locals {
    allowed_tags = [
      for k, v in var.TAILSCALE_ACL.tagOwners: k
    ]
  }

  resource "tailscale_device_tags" "tags" {
    
    for_each = {
      for index, device in data.tailscale_devices.devices.devices: device.name => device
    }

    device_id = each.value.id
    tags      = [
      for t in split("-", split(".", each.value.name)[0]):
        "tag:${t}" if contains(local.allowed_tags, "tag:${t}")
    ]

  }