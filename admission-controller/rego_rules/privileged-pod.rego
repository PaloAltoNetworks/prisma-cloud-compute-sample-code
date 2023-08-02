# PolicyName: PSS - Baseline - Pod should not run privileged containers
# Description: This admission rule identifies Pods that creates privileged containers


match[{"msg": msg}] {
	input.request.operation == "CREATE"
	input.request.kind.kind == "Pod"
	input.request.object.spec.containers[_]
    container.securityContext.privileged == true
    name := input.request.object.metadata.name
    msg := sprintf("Pods with Privileged containers created in: %v",[name])
}