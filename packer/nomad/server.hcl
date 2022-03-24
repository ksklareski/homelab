server{
  enabled = true

  server_join {
      retry_join = [ "nomad-server-1" ]
      retry_interval = "15s"
  }
}