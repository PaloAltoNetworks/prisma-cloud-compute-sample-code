# PolicyName: PSS - Baseline - StatefulSet should not run privileged containers
# Description: This admission rule identifies StatefulSets that creates privileged containers


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    container := input.request.object.spec.template.spec.containers[_]
    container.securityContext.privileged == true
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with Privileged containers created in: %v",[name])
}