# PolicyName: PSS - Baseline - DaemonSet should not run privileged containers
# Description: This admission rule identifies DaemonSets that creates privileged containers


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "DaemonSet"
    container := input.request.object.spec.template.spec.containers[_]
    container.securityContext.privileged == true
    name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with Privileged containers created in: %v",[name])
}