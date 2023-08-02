# PolicyName:  PSS - Restricted - DaemonSet with containers running as root users
# Description: This admission rule identifies DaemonSets that are running containers as root users

match[{"msg": msg}] {
	input.request.operation == "CREATE"
	input.request.kind.kind == "DaemonSet"
    container = input.request.object.spec.template.spec
    container.securityContext.runAsUser == 0
	name := input.request.object.metadata.name
    msg := sprintf("DaemonSet running containers with root user identified for: %v",[name])
}