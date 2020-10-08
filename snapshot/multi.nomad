job "snapshot-oct" {

  multiregion {

    strategy {
      max_parallel = 1
      on_failure   = "fail_local"
    }

    region "ap-southeast-1" {
      count       = 2
      datacenters = ["NORTH"]
    }

    region "ap-southeast-2" {
      count       = 3
      datacenters = ["SOUTH"]
    //   datacenters = ["south", "south-east"]
    }

  }

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "2m"
    progress_deadline = "3m"
    auto_revert       = true
    auto_promote      = true
    canary            = 1 
    stagger           = "30s"
  }
    
  group "cache" {

    count = 0

    task "redis" {
      driver = "docker"

      config {
        image = "redis:6.0"

        port_map {
          db = 6379
        }
      }

      resources {
        cpu    = 256
        memory = 128

        network {
          mbits = 10
          port "db" {}
        }
      }
    }
  }
}