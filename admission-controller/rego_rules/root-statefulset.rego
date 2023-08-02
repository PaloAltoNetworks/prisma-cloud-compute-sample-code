# PolicyName: PSS - Restricted - StatefulSet with containers running as root
# Description: This admission rule identifies StatefulSets that are running containers as root


match[{"msg": msg}] {
	input.request.operation == "CREATE"
	input.request.kind.kind == "StatefulSet"
    container = input.request.object.spec.template.spec.containers[_]
    container.securityContext.runAsNonRoot == true
	name := input.request.object.metadata.name
    msg := sprintf("StatefulSet running containers as root identified for: %v",[name])
}