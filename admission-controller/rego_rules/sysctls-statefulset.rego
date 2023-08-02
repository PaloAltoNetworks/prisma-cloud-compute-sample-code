# PolicyName:  PSS - Baseline - StatefulSet with containers that does not use safe sysctls
# Description: This policy identifies StatefulSets with containers that does not use safe sysctls

# Below are the safe sysctls as per Kubernetes documentation, sysctls can be removed/added as needed
pssBaselineSysctls = {"Undefined", "nil","kernel.shm_rmid_forced","net.ipv4.ip_local_port_range","net.ipv4.ip_unprivileged_port_start","net.ipv4.tcp_syncookies", "net.ipv4.ping_group_range"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    container := input.request.object.spec.template.spec
    containerSysctls := {sysctl | sysctl := container.securityContext.sysctls[_].name}
    unsafeSysctls := pssBaselineSysctls - containerSysctls
    count(unsafeSysctls) != 0
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with containers using unsafe sysctls identified in %v", [name])
}

