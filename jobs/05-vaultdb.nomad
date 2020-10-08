job "postgres-nomad-demo" {
  datacenters = ["DC1"]
  region = "prod"

   affinity {
    attribute = "${attr.unique.hostname}"
    value     = "nec3"
    weight    = 100
  }

  group "db" {

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/postgres-nomad-demo:latest"
        port_map {
          db = 5432
        }
      }
      resources {
        network {
          port  "db"{
        static = 5432
      }
        }
      }

      service {
        name = "database"
        port = "db"

        check {
          type     = "tcp"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
