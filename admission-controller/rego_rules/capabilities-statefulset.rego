# PolicyName:  PSS - Restricted - StatefulSet with containers that run with restricted capabilities
# Description: This policy identifies StatefulSets with containers that run with restricted capabilities

authorizedcapabilities = {"NET_BIND_SERVICE"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    container := input.request.object.spec.template.spec.containers[_].securityContext
    addedcap := {cap | cap := container.capabilities.add[_]}
    unauthcapabilities := addedcap - authorizedcapabilities
    count(unauthcapabilities) != 0
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with containers using restricted/unauthorized capabilities identified in %v", [name])
}
