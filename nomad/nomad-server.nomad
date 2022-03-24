variables {
  min_healthy_sec = 30
  server_1_ip = "192.168.1.221"
  server_2_ip = "192.168.1.222"
  server_3_ip = "192.168.1.223"
  server_1_hostname = "nomad-server-1"
  server_2_hostname = "nomad-server-2"
  server_3_hostname = "nomad-server-3"
  image_url = "registry:5000/nomad-server:ubuntu"
  container_cpu = 200
  container_mem = 200
}

job "nomad-server" {
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

  group "nomad-server-group-1" {
    volume "nomad-server-1" {
      type      = "host"
      read_only = false
      source    = "nomad-server-1"
    }
    task "nomad-server-1" {
      driver = "docker"

      config {
        image = "${var.image_url}"
	      network_mode = "nomad_net"
        ipv4_address = "${var.server_1_ip}"
        hostname = "${var.server_1_hostname}"
      }

      volume_mount {
        volume      = "nomad-server-1"
        destination = "/opt/nomad"
        read_only   = false
      }

      resources {
        cpu = "${var.container_cpu}"
        memory = "${var.container_mem}" 
      }
    }
  }
  
  group "nomad-server-group-2" {
    volume "nomad-server-2" {
      type      = "host"
      read_only = false
      source    = "nomad-server-2"
    }

    task "nomad-server-2" {
      driver = "docker"

      config {
        image = "${var.image_url}"
	      network_mode = "nomad_net"
        ipv4_address = "${var.server_2_ip}"
        hostname = "${var.server_2_hostname}"
      }

      volume_mount {
        volume      = "nomad-server-2"
        destination = "/opt/nomad"
        read_only   = false
      }

      resources {
        cpu = "${var.container_cpu}"
        memory = "${var.container_mem}" 
      }
    }
  }

  group "nomad-server-group-3" {
    volume "nomad-server-3" {
      type      = "host"
      read_only = false
      source    = "nomad-server-3"
    }
    
    task "nomad-server-3" {
      driver = "docker"

      config {
        image = "${var.image_url}"
	      network_mode = "nomad_net"
        ipv4_address = "${var.server_3_ip}"
        hostname = "${var.server_3_hostname}"
      }

      volume_mount {
        volume      = "nomad-server-3"
        destination = "/opt/nomad"
        read_only   = false
      }

      resources {
        cpu = "${var.container_cpu}"
        memory = "${var.container_mem}" 
      }
    }
  }
}