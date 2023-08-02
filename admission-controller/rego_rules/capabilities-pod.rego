# PolicyName:  PSS - Restricted - Pod with containers that run with restricted capabilities
# Description: This policy identifies Pods with containers that run with restricted capabilities

authorizedcapabilities = {"NET_BIND_SERVICE"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    container := input.request.object.spec.containers[_].securityContext
    addedcap := {cap | cap := container.capabilities.add[_]}
    unauthcapabilities := addedcap - authorizedcapabilities
    count(unauthcapabilities) != 0
    name := input.request.object.metadata.name
    msg := sprintf("Pod with containers using restricted/unauthorized capability identified in %v", [name])
}

