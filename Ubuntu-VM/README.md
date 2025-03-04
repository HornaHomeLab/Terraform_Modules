# Proxmox Ubuntu Server VM

This module requires proxmox vm template named `ubuntu-cloud-init-template`. 


## Credentials
File `credentials.auto.tfvars` should be located in root, where this module is used in format:

```
proxmox_api_url = "https://<server_ip_address>:8006/api2/json"  # Your Proxmox IP Address
proxmox_api_token_id = "<your-api-token-id>"  # API Token ID
proxmox_api_token_secret = "<your-api-token-secret>"
```

To make credentials file working you also need additional `variables.tf` file beside the `credentials.auto.tfvars`, in format

```
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

```