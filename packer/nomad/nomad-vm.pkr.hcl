# TODO: Write first boot script that reads ip addr from CD drive and sets interface to that

packer {}

locals {
  artifact_dir = "Z:/packer/artifacts/nomad"
}

source "hyperv-vmcx" "rocky8" {
  boot_wait = "30s"
  clone_from_vm_name = "rocky8-base"
  communicator = "ssh"
  cpus = 2
  generation = 1
  headless = true
  output_directory = "${local.artifact_dir}"
  shutdown_command = "echo 'packer' | sudo -S shutdown -h now"
  skip_export = true
  ssh_handshake_attempts = 200
  ssh_timeout = "10m"
  ssh_username = "root"
  ssh_password = "76954769s@"
  switch_name = "Default Switch"
  temp_path = "Z:/temp"
  vm_name = "nomad-build"
}

build {
  name    = "nomad"
  sources = ["source.hyperv-vmcx.rocky8"]

  # Copy in firstboot script
  provisioner "file" {
    source = "firstboot.service"
    destination = "/etc/systemd/system/firstboot.service"
  }

  # Copy in nomad config so it run in client mode
  provisioner "file" {
    sources = ["./nomad.hcl","./client.hcl"]
    destination = "/etc/nomad.d/"
  }

  provisioner "file" {
    source = "mount_cd.sh"
    destination = "/tmp/mount_cd.sh"
  }

  provisioner "shell" {
    # TODO: Set hostname
    inline = [
      "cat /etc/os-release",
      "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo",
      "sudo yum -y install nomad",
      "chmod +x /tmp/mount_cd.sh",
      "systemctl enable firstboot.service"
    ]
  }

  # Rename artifact
  // post-processor "shell-local" {
  //   inline = ["move '${local.artifact_dir}/Virtual Hard Disks/rocky-8-base.vhdx' '${local.artifact_dir}/Virtual Hard Disks/nomad-client.vhdx'"]
  // }
}