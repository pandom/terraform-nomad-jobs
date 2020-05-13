provider "nomad" {
}

# Register a job
resource "nomad_job" "fabio" {
  jobspec = "${file("${path.module}/jobs/tf-fabio.nomad")}"
}
# Register a job
resource "nomad_job" "microbot" {
  jobspec = "${file("${path.module}/jobs/tf-microbot.nomad")}"
}