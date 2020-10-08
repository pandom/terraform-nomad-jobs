job "nomad-vault" {
  datacenters = ["DC1"]
  region = "prod"

  group "demo-vault" {
    task "server-run" {

      vault {
        policies = ["access-tables"]
      }

      driver = "docker"
      config {
        image = "hashicorp/nomad-vault-demo:latest"
        port_map {
          http = 8080
        }

        volumes = [
          "secrets/config.json:/etc/demo/config.json"
        ]
      }

      template {
        data = <<EOF
{{ with secret "database/creds/accessdb" }}
  {
    "host": "10.7.0.23",
    "port": 5432,
    "username": "{{ .Data.username }}",
    "password": {{ .Data.password | toJSON }},
    "db": "postgres"
  }
{{ end }}
EOF
        destination = "secrets/config.json"
      }

      resources {
        network {
          port "http" {}
        }
      }

      service {
        name = "nomad-vault-demo"
        port = "http"

        tags = [
          "urlprefix-/",
        ]

        check {
          type     = "tcp"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}