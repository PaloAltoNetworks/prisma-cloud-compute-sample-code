# PolicyName: PSS - Baseline - StatefulSet with containers using restricted SELinux options
# Description: This policy identifies StatefulSets with containers using restricted SELinux options


seLinuxOptionsTypes = {"container_t", "container_init_t", "container_kvm_t"}

options_verify(seLinuxOptions){
    not seLinuxOptionsTypes[seLinuxOptions.type]
    seLinuxOptions.user 
    seLinuxOptions.role
}
match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    container := input.request.object.spec.template.spec.containers[_].securityContext.seLinuxOptions
    not options_verify(container)
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with containers using restricted SELinuxOptions identified in %v", [name])
}

