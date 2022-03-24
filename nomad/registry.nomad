variables {
  min_healthy_sec = 10
  registry_ip = "192.168.1.231"
  registry_port = 5000
}

job "registry" {
  datacenters = ["home"]
  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "${var.min_healthy_sec}s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }
  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "${var.min_healthy_sec}s"
    healthy_deadline = "5m"
  }

  group "registry-group" {
    network {
      port "registry" { static = "${var.registry_port}" }
    }

    task "registry-task" {
      driver = "docker"

      config {
        image = "registry"
	      ports = ["registry"]
        network_mode = "nomad_net"
        ipv4_address = "${var.registry_ip}"
      }
      resources {
        memory     = 100
      }
    }
  }
}