# TODO: Write first boot script that reads ip addr from CD drive and sets interface to that

packer {}

locals {
  artifact_dir = "Z:/packer/artifacts/nomad"
}

source "hyperv-vmcx" "ubuntu" {
  boot_wait = "30s"
  clone_from_vm_name = "ubuntu-base"
  communicator = "ssh"
  cpus = 2
  generation = 1
  headless = true
  output_directory = "${local.artifact_dir}"
  shutdown_command = "echo 'packer' | sudo -S shutdown -h now"
  skip_export = false
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
  sources = ["source.hyperv-vmcx.ubuntu"]

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
  
  provisioner "shell" {
    // inline = [
    //   "apt update && apt install -y ca-certificates curl gnupg  lsb-release",
    //   "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
    //   "sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"",
    //   "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
    //   "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
    //   "apt update && apt install -y docker-ce docker-ce-cli containerd.io nomad",
    //   "fstrim -a"
    // ]
    script = "./nomad-provision.sh"
  }

  # NOTE: Exporting as VM yields differencing disk. I have not had luck with packer exporting
    # only the disk. Doesnt seem to persist changes, so we do this instead.
  post-processor "shell-local" {
    inline = ["merge-vhd -Path 'Z:\packer\artifacts\nomad\Virtual Hard Disks\ubuntu-20-base_3EE1FCD5-1F7A-402E-B163-3F029E794B01.avhdx' -DestinationPath 'Z:\packer\artifacts\nomad\Virtual Hard Disks\ubuntu-20-base.vhdx'"]
  }
}