# PolicyName:  PSS - Restricted - StatefulSet that allow container privilege escalation
# Description: This admission rule identifies StatefulSets with container privilege escalation



match[{"msg": msg}] {
    input.request.operation == "CREATE"     
	input.request.kind.kind == "StatefulSet"
    container := input.request.object.spec.template.spec.containers[_]
    container.securityContext.allowPrivilegeEscalation == true
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with container with privilege escalation identified in %v",[name])

}