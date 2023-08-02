# PolicyName:  PSS - Baseline - StatefulSets that does not run containers with default proc mount
# Description: This admission rule identifies StatefulSets with containers that does not use default proc mount


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    container := input.request.object.spec.template.spec.containers[_]
    procValue = container.securityContext.procMount
    procValue  != "default"
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with container without default proc mount identified in %v", [name])
}