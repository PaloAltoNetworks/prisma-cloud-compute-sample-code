# PolicyName:  PSS - Restricted - StatefulSet with containers that does not use allowed seccomp profiles
# Description: This policy identifies StatefulSets with containers that does not use allowed secomp profiles.

allowed_profile_types = {"RuntimeDefault", "Localhost"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    container = input.request.object.spec.template.spec.securityContext
    proftype := container.seccompProfile.type
    not allowed_profile_types[proftype]
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with containers using not allowed seccomp profiles identified in %v", [name])
}