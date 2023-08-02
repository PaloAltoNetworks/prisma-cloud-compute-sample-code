# PolicyName:  PSS - Baseline - Pod with containers with seccomp profile that is not using RuntimeDefault
# Description: This policy identifies pods with containers using seccomp profiles that are not RuntimeDefault


match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    container := input.request.object.spec.securityContext
    not container.seccompProfile.type == "RuntimeDefault"
    localhostProfileType := container.seccompProfile.localhostProfile
    name := input.request.object.metadata.name
    msg := sprintf("Pod with container without runtimeDefault seccomp profile identified in %v", [localhostProfileType])
}