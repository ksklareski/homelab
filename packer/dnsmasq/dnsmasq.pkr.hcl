packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

variable "registy_addr" {
  type = string
  default = "registry"
}

source "docker" "alpine" {
  changes = [
    "ENTRYPOINT [\"/usr/sbin/dnsmasq\", \"--no-daemon\"]"
  ]
  image  = "alpine:3.15"
  commit = true
}

build {
  name    = "dnsmasq"
  sources = ["source.docker.alpine"]

  provisioner "shell" {
    inline = [
      "echo Installing dnsmasq",
      "apk add --no-cache dnsmasq",
      "mkdir -p /opt/dnsmasq",
    ]
  }

  provisioner "file" {
    source = "./dnsmasq.conf"
    destination = "/etc/dnsmasq.conf"
  }

  provisioner "file" {
    source = "./dns-hosts"
    destination = "/opt/dnsmasq/dns-hosts"
  }

  post-processors {

    post-processor "docker-tag" {
      repository =  "${var.registy_addr}:5000/dnsmasq"
      tags = ["alpine"]
    }

    post-processor "docker-push" {}
  }
}