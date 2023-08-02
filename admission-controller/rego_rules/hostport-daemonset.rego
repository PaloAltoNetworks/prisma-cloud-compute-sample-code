# PolicyName: PSS - Baseline - Daemonset that run containers with hostPorts
# Description: The admission rule identifies Daemonset with container using hostPorts


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "DaemonSet"
    container := input.request.object.spec.template.spec.containers[_]
    container.ports[_].hostPort
    name := input.request.object.metadata.name
    msg := sprintf("Daemonset created with HostPort in: %v",[name])
}