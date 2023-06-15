![Header](scheme.drawio.png)

## General outline of the project

This project is meant to configure an existing tailnet with custom DNS, keys and ACLs.

1. Configure a custom DNS server other than MagicDNS. That's done in order to resolve requests for an internally configured proxy.
2. Disable key expity on crucial *infrastructure* nodes like the DNS server, Docker server, etc.
3. Set ACL rules to prevent unwanted communication between nodes.
    This is useful when your tailnet has different people and you don't want them to see the rest of the network. The ACL are based on node tags.
4. Tag nodes.
    They are tagged **recursively**, based on a naming convention. The name of each node has:
    * **The type of node** - server, client, device
    * **The access stage** - whether or not this node should be public or private. A public node can be accessed by all other nodes on the network, opposed to a private one.
    * **The access role** - insider and outsider. You, the admin are an insider. Your SO are insiders. The discord friend you gave access to, is an outsider. They can see only public nodes.
    * **The location** - personally, I use a 3-letter abbr for different cities as my nodes are all accross the country.
    * **The name** - Docker, adguard, pihole, gitea. Initials for people - John Doe > jd.

## 📃 Prerequisites

1. A Tailscale network with some devices
2. A Tailscale [API key](https://login.tailscale.com/admin/settings/keys)
3. A device naming convention like so: `type-access-role-location-name`

## 📝 Naming components

1. Type\*
    * server
    * laptop
    * phone
2. Access\*
    * public
    * private
3. Role\*
    * insider
    * outsider
4. Location
    * London > lon
    * Sofia > sof
5. Name
    * docker
    * adguard
    * John Doe > jd

⚠️ \* If you are using other `type`, `access` and `role` tags, you need to define them in the ACL config under `tagOwners`. Otherwise they will not be applied.

## 🔀 Possible combinations

All nodes require `type`, `access` and `role` defined. By combining them, you can achieve a basic but sufficient in most cases accsess control.

```
type-access-role-location-name

server-public-insider-sof-docker
laptop-private-outsider-sof-jd
```

![Ейьпзве](scheme2.drawio.png)

## 💡 Commands used in this project
```bash
terraform init -upgrade

terraform apply -auto-approve

terraform apply -destroy -auto-approve
```

## 📝 Variables used in this project
Rename the `variables.auto.tfvars.example` to `variables.auto.tfvars` and fill it in.
```py
TAILSCALE_TAILNET = "email@mail.tld"
# https://login.tailscale.com/admin/settings/keys
# Temp API key. 90 days since 25/04/2023
TAILSCALE_API_KEY = "tskey-api-yourapikeyhere"

TAILSCALE_DNS_SRV = "server-public-insider-your-dns-server-name"

TAILSCALE_ACL = {
    
    # https://tailscale.com/kb/1018/acls/#tag-owners
    # It's important to define all the tags that you are going to use in the machine names here.
    "tagOwners": {
      "tag:server":   ["mail@email.tld"],
      "tag:laptop":   ["mail@email.tld"],
      "tag:phone":    ["mail@email.tld"],
      "tag:outsider": ["mail@email.tld"],
      "tag:insider":  ["mail@email.tld"],
      "tag:public":   ["mail@email.tld"],
      "tag:private":  ["mail@email.tld"],
    },
   
    # https://tailscale.com/kb/1068/acl-tags/#acls
    "acls" : [
      # Match absolutely everything.
      # {"action": "accept", "src": ["*"], "dst": ["*:*"]},
      {
        "action": "accept",
        "src":    ["tag:insider"],
        "dst":    ["tag:public:*", "tag:private:*"],
      },
      {
        "action": "accept",
        "src":    ["tag:outsider"],
        "dst":    ["tag:public:443", "tag:public:80", "tag:public:53"],
      },
    ],
  }
```

## 📖 Relevant Documentation

### 🌟 Terraform Docker Provider
* [Documentation](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container)

### 🌟 Terraform Tailscale Provider
* [Basic Config](https://registry.terraform.io/providers/davidsbond/tailscale/latest/docs)


### 🌟 Tailscale Docs
* [API Keys](https://tailscale.com/kb/1101/api/)
* [DNS](https://tailscale.com/kb/1054/dns/)
* [ACLs](https://tailscale.com/kb/1068/acl-tags/)


### 🌟 Misc useful resources

