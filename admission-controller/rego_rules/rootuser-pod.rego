# PolicyName:  PSS - Restricted - Pod with containers running as root users
# Description: This admission rule identifies Pods that are running containers as root users

match[{"msg": msg}] {
	input.request.operation == "CREATE"
	input.request.kind.kind == "Pod"
    container = input.request.object.spec
    container.securityContext.runAsUser == 0
	name := input.request.object.metadata.name
    msg := sprintf("Pod running containers with root user identified for: %v",[name])
}