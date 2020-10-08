
job "nuslifecycle" {
  datacenters = ["DC1"]
  region = "prod"
  priority = 70
  # Rolling updates
  update {
      max_parallel     = 2
      min_healthy_time = "30s"
      healthy_deadline = "3m"
      # Add 5 when doing a new version.
      canary = 5
       # Enable automatically reverting to the last stable job on a failed
        # deployment.
    //   auto_revert = true
    //   auto_promote = false
    }

  group "web" {
    # We want 9 web servers initially
    count = 10

    task "microbot" {
      driver = "docker"
      config {
        image = "pandom/test-frontend:1.0"
        port_map {
          http = 80
        }
      }
      service {
        name = "microbot"
        tags = ["urlprefix-/"]
        port = "http"
        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }
      env {
        DEMO_NAME = "nomad-intro"
      }
      resources {
        cpu = 100
        memory = 32
        network {
          mbits = 100
          port "http" {}
        }
      }
    }
  }
}
