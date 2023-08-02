# PolicyName: PSS - Baseline - Deployment that run containers with hostPorts
# Description: The admission rule identifies Deployments with container using hostPorts


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Deployment"
    container := input.request.object.spec.template.spec.containers[_]
    container.ports[_].hostPort
    name := input.request.object.metadata.name
    msg := sprintf("Deployment created with HostPort in: %v",[name])
}