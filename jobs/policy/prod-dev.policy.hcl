#namespace level read with specific capabilities.
namespace "default" {
  policy = "read"
  capabilities = ["submit-job","dispatch-job","read-logs"]
}
#capabilities can be specific listed and read by default would allow 
# list-jobs
# read-job
# csi-list-volume
# csi-read-volume
# list-scaling-policies
# read-scaling-policy
# read-job-scaling
# 