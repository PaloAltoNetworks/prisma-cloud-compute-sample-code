# PolicyName:  PSS - Baseline - Pod that does not run containers with default proc mount
# Description: This admission rule identifies Pods with containers that does not use default proc mount


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    container := input.request.object.spec.containers[_]
    procValue = container.securityContext.procMount
    procValue  != "default"
    name := input.request.object.metadata.name
    msg := sprintf("Pod with container without default proc mount identified in %v", [name])
}