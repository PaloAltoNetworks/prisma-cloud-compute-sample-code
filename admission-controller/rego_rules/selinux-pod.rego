# PolicyName: PSS - Baseline - Pod with containers using restricted SELinux options
# Description: This policy identifies pods with containers using restricted SELinux options


seLinuxOptionsTypes = {"container_t", "container_init_t", "container_kvm_t"}

options_verify(seLinuxOptions){
    not seLinuxOptionsTypes[seLinuxOptions.type]
    seLinuxOptions.user 
    seLinuxOptions.role
}
match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    container := input.request.object.spec.containers[_].securityContext.seLinuxOptions
    not options_verify(container)
    name := input.request.object.metadata.name
    msg := sprintf("Pod with containers using restricted SELinuxOptions identified in %v", [name])
}



