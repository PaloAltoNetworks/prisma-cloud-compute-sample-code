# PolicyName:  PSS - Restricted - StatefulSet with containers running as root users
# Description: This admission rule identifies StatefulSets that are running containers as root users

match[{"msg": msg}] {
	input.request.operation == "CREATE"
	input.request.kind.kind == "StatefulSet"
    container = input.request.object.spec.template.spec
    container.securityContext.runAsUser == 0
	name := input.request.object.metadata.name
    msg := sprintf("StatefulSet running containers with root user identified for: %v",[name])
}