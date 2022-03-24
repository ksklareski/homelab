# TODO: Write first boot script that reads ip addr from CD drive and sets interface to that

packer {}

locals {
  artifact_dir = "Z:/packer/artifacts/ubuntu"
}

source "hyperv-vmcx" "ubuntu" {
  boot_wait = "30s"
  clone_from_vm_name = "ubuntu20-base"
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
  vm_name = "ubuntu-build"
}

build {
  name    = "ubuntu-base"
  sources = ["source.hyperv-vmcx.ubuntu"]

  provisioner "shell" {
    # TODO: Set hostname
    inline = [
      "systemctl disable --now systemd-resolved",
      "rm /etc/resolv.conf",
      "echo 'nameserver 1.1.1.1' > /etc/resolv.conf",
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwYPrGI/IVpMXcBN3CMbH4NQ63fCKVJg4j/YIxN4XLOjJm5M9q4TNUxsr2HtKbFL3isGdZrK9bSXiKN38LSvHJMUpk3T03A+jRz704ix73X4kxaYC89nepN9WBrEbAwUX5Gae1m3BasM8w8N1Tv2ata7CBK8NPE6YAN8EN5RRifIboabVagyt/6fKLK2v1Xq3VYdG5FdNR/+78nurPKfXrxEgeCsxRB+78zpQJCAJni2iCmSfW58hS1g61PKQs9sMMt9erGo3AS/I63iBfVg9koYn+McvMpgxM/GBUXl13SdzK8YpPOu1muo3DFHobg4ROlk62DuYGbCoIzIWWnpel kylesklareski@icinga-master' >> ~/.ssh/authorized_keys",
      "apt update && apt install -y curl software-properties-common cloud-init",
      "fstrim -a"
    ]
  }
}