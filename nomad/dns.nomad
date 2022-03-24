variables {
  min_healthy_sec = 10
  dns_1_ip = "192.168.1.2"
  dns_2_ip = "192.168.1.3"
  dns_port = 53
  default_gw = "192.168.1.1"
  network_int = "eth0"
  exec_mem = 50
  container_mem = 100
  forward_to = ["192.168.1.1","1.1.1.1","8.8.8.8"]
  image_url = "192.168.1.231:5000/dnsmasq:alpine"
}

job "dns" {
  datacenters = ["home"]
  type = "service"

  meta {
    // This essentially forces an update every time the job is run
    uuid = uuidv4()
  }

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

  group "dns-group-1" {
    spread {
		  attribute =  "${node.datacenter}"
      weight = 100
	  }
    task "dns-task" {
      driver = "docker"

      config {
        image = "${var.image_url}"
        network_mode = "nomad_net"
        ipv4_address = "${var.dns_1_ip}"
        dns_servers = "${var.forward_to}"
      }
      resources {
        memory = "${var.container_mem}"      
      }
    }
  }

  group "dns-group-2" {
    task "dns-task" {
      driver = "docker"

      config {
        image = "${var.image_url}"
        network_mode = "nomad_net"
        ipv4_address = "${var.dns_2_ip}"
        dns_servers = "${var.forward_to}"
      }
      resources {
        memory = "${var.container_mem}"      
      }
    }
  }
}