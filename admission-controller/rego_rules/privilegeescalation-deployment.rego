# PolicyName:  PSS - Restricted - Deployment that allow container privilege escalation
# Description: This admission rule identifies Deployments with container privilege escalation

match[{"msg": msg}] {
    input.request.operation == "CREATE"     
	input.request.kind.kind == "Deployment"
    container := input.request.object.spec.template.spec.containers[_]
    container.securityContext.allowPrivilegeEscalation == true
    name := input.request.object.metadata.name
    msg := sprintf("Deployment with container with privilege escalation identified in %v",[name])

}