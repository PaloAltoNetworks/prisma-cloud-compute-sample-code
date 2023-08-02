# PolicyName:  PSS - Restricted - Pod that allow container privilege escalation
# Description: This admission rule identifies Pods with container privilege escalation

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    container := input.request.object.spec.containers[_]
    container.securityContext.allowPrivilegeEscalation == true
    name := input.request.object.metadata.name
    msg := sprintf("Pod with container privilege escalation is identified in %v",[name])
}