# PolicyName: PSS - Baseline - Pod that run containers with hostPorts
# Description: The admission rule identifies Pods with container using hostPorts


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    input.request.object.spec.containers[_].ports[_].hostPort
    name := input.request.object.metadata.name
    msg := sprintf("Pod created with HostPort in: %v",[name])
}