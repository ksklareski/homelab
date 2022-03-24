client {
  enabled = true
  server_join {
    retry_join = [ "nomad-server-1", "nomad-server-2", "nomad-server-3" ]
    retry_interval = "15s"
  }
  host_volume "nomad-server-1" {
    path = "/tmp/nomad-server-1"
    read_only = false
  }
  host_volume "nomad-server-2" {
    path = "/tmp/nomad-server-2"
    read_only = false
  }
  host_volume "nomad-server-3" {
    path = "/tmp/nomad-server-3"
    read_only = false
  }
}

ports {
  http = 4746
  rpc  = 4747
  serf = 4748
}

// Do we need this anymore?
plugin "raw_exec" {
  config {
    enabled = true
  }
}