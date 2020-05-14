job "tf-microbot" {
  datacenters = ["aws"]
  priority = 70
  # Rolling updates
  update {
    stagger = "10s"
    max_parallel = 5
  }

  group "web" {
    # We want 9 web servers initially
    count = 20

    task "microbot" {
      driver = "docker"
      config {
        image = "dontrebootme/microbot:v1"
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
