variable "client_id" {
  default = "ac08155b-375d-4604-9be0-c0774f70c878"
}

variable "client_secret" {
  default = ""
}

variable "azure_image_version" {
  default = "1.0.1"
}

variable "azure_location" {
  default = "uksouth"
}

variable "azure_object_id" {
  default = ""
}

variable "resource_group_name" {
  default = "hmcts-image-gallery-rg"
}

variable "azure_storage_account" {
  default = ""
}

variable "subscription_id" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "ssh_user" {
  default = ""
}

variable "ssh_password" {
  default = ""
}

variable "image_name" {
  default = "bastion-ubuntu"
}

source "azure-arm" "azure-os-image" {
  azure_tags = {
    imagetype = "bastion-ubuntu"
    timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  }
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "18.04-LTS"
  location                          = var.azure_location
  managed_image_name                = "bastion-ubuntu-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  managed_image_resource_group_name = var.resource_group_name
  os_type                           = "Linux"
  ssh_pty                           = "true"
  ssh_username                      = var.ssh_user
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  vm_size                           = "Standard_DS2_v2"

  shared_image_gallery_destination {
    subscription        = var.subscription_id
    resource_group      = var.resource_group_name
    gallery_name        = "hmcts"
    image_name          = var.image_name
    image_version       = var.azure_image_version
    replication_regions = ["UK South"]
  }
}

build {
  sources = ["source.azure-arm.azure-os-image"]

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "provision-bastion.sh"
  }

}