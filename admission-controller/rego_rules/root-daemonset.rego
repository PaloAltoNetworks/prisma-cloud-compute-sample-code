# PolicyName: PSS - Restricted - DaemonSet with containers running as root
# Description: This admission rule identifies DaemonSets that are running containers as root


match[{"msg": msg}] {
	input.request.operation == "CREATE"
	input.request.kind.kind == "DaemonSet"
    container = input.request.object.spec.template.spec.containers[_]
    container.securityContext.runAsNonRoot == true
	name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with containers running as root identified for: %v",[name])
}