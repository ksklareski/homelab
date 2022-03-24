client {
  enabled = true
  servers = ["192.168.1.221"]
}

ports {
  http = 4746
  rpc  = 4747
  serf = 4748
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}