# Ops teams are not allowed to modify running jobs ergo Read over namespace
namespace "default" {
  policy = "read"
}
# Ops teams will need to perform cluster maintenance and are granted node/agent/operator/plugin write
node {
  policy = "write"
}

agent {
  policy = "write"
}

operator {
  policy = "write"
}

plugin {
  policy = "list"
}