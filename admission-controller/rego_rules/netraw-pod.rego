# PolicyName: PSS - Baseline - Pod should not run containers with the NET_RAW capability
# Description : This admission rule identifies pods that run containers with NET_RAW Capability

match[{"msg": msg}] {
    input.request.operation == "CREATE"     
    input.request.kind.kind == "Pod"
    container := input.request.object.spec.containers[_]
    capability := container.securityContext.capabilities.add[_]
    capability == "NET_RAW"
    name := input.request.object.metadata.name
    msg := sprintf("Pod with NET_RAW capability identified in: %v",[name])
}
