packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  changes = [
    "EXPOSE 4646 4647 4648 4648/udp",
    "ENTRYPOINT [\"/usr/bin/nomad\", \"agent\", \"-config=/etc/nomad.d\"]"
  ]
  image  = "ubuntu:20.04"
  commit = true
}

build {
  name    = "nomad"
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    inline = [
      "apt update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata",
      "apt install -y sudo curl software-properties-common bridge-utils",
      "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
      "sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"",
      "apt update",
      "apt install -y nomad",
    ]
    // inline = [
    //   "chmod +x /usr/bin/nomad",
    //   "nomad --version",
    //   "mkdir -p /etc/nomad.d",
    //   "mkdir -p /opt/nomad",
    // ]
  }

  provisioner "file" {
    source = "./nomad.hcl"
    destination = "/etc/nomad.d/nomad.hcl"
  }

  provisioner "file" {
    source = "./server.hcl"
    destination = "/etc/nomad.d/server.hcl"
  }

  post-processors {
    post-processor "docker-tag" {
      repository =  "registry:5000/nomad-server"
      tags = ["ubuntu"]
    }

    post-processor "docker-push" {}
  }
}