# PolicyName:  PSS - Restricted - Daemonset with containers that run with restricted capabilities
# Description: This policy identifies Daemonsets with containers that run with restricted capabilities

authorizedcapabilities = {"NET_BIND_SERVICE"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Daemonset"
    container := input.request.object.spec.template.spec.containers[_].securityContext
    addedcap := {cap | cap := container.capabilities.add[_]}
    unauthcapabilities := addedcap - authorizedcapabilities
    count(unauthcapabilities) != 0
    name := input.request.object.metadata.name
    msg := sprintf("Daemonset with containers using restricted/unauthorized capabilities identified in %v", [name])
}
