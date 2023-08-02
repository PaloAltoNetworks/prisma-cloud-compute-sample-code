# PolicyName: PSS - Baseline - StatefulSet that run containers with hostPorts
# Description: The admission rule identifies StatefulSets with container using hostPorts


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    container := input.request.object.spec.template.spec.containers[_]
    container.ports[_].hostPort
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet created with HostPort in: %v",[name])
}