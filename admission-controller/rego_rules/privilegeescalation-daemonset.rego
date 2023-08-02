# PolicyName:  PSS - Restricted - DeamonSet that allow container privilege escalation
# Description: This admission rule identifies DeamonSets with container privilege escalation

match[{"msg": msg}] {
    input.request.operation == "CREATE"     
	input.request.kind.kind == "DeamonSet"
    container := input.request.object.spec.template.spec.containers[_]
    container.securityContext.allowPrivilegeEscalation == true
    name := input.request.object.metadata.name
    msg := sprintf("DeamonSet with container with privilege escalation identified in %v",[name])

}