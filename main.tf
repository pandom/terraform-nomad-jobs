provider "nomad" {
    address = "http://burkey-pa6px8sygq4zxxlm7-nomad-1784565306.ap-southeast-2.elb.amazonaws.com:4646"
}

# Register a job
resource "nomad_job" "fabio" {
    jobspec = <<EOT
    job "fabio" {
  datacenters = ["aws"]
  type = "system"

  group "fabio" {
    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          mbits = 100
          port "lb" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
          port "tcp" {
            static = 25565
          }
        }
      }
    }
  }
}
EOT
}

resource "nomad_job" "microbot" {
    jobspec = <<EOT
    job "microbot" {
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
EOT
}
