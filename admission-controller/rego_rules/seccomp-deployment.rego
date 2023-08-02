# PolicyName:  PSS - Baseline - Deployment with containers that use unauthorized seccomp profiles
# Description: This policy identifies Deployments with containers using unauthorized seccomp profiles

# Add authorized seccomp profiles here
authorized_profile_types = {"profile1", "profile2"}
match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Deployment"
    container = input.request.object.spec.template.spec.securityContext
    localhost := container.seccompProfile.localhostProfile
    not authorized_profile_types[localhost]
    name := input.request.object.metadata.name
    msg := sprintf("Deployment with containers using unauthorized seccomp profiles identified in %v", [name])
}
