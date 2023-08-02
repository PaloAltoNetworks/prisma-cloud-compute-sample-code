# PolicyName: PSS - Restricted - Pod with containers running as root
# Description: This admission rule identifies Pods that are running containers as root


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    container = input.request.object.spec.containers[_]
    container.securityContext.runAsNonRoot == true
    name := input.request.object.metadata.name
    msg := sprintf("Pod with container running as root identified in pod %v",[name])
}