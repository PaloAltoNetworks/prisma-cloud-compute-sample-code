# PolicyName:  PSS - Baseline - DaemonSet with containers that use unauthorized seccomp profiles
# Description: This policy identifies DaemonSets with containers using unauthorized seccomp profiles

# Add authorized seccomp profiles here
authorized_profile_types = {"profile1", "profile2"}
match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "DaemonSet"
    container = input.request.object.spec.template.spec.securityContext
    localhost := container.seccompProfile.localhostProfile
    not authorized_profile_types[localhost]
    name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with containers using unauthorized seccomp profiles identified in %v", [name])
}
