# PolicyName:  PSS - Baseline - Pod with containers that does not use safe sysctls
# Description: This policy identifies Pods with containers that does not use safe sysctls

# Below are the safe sysctls as per Kubernetes documentation, sysctls can be removed/added as needed
pssBaselineSysctls = {"kernel.shm_rmid_forced","net.ipv4.ip_local_port_range","net.ipv4.ip_unprivileged_port_start","net.ipv4.tcp_syncookies", "net.ipv4.ping_group_range"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    container := input.request.object.spec
    containerSysctls := {sysctl | sysctl := container.securityContext.sysctls[_].name}
    unsafeSysctls := containerSysctls - pssBaselineSysctls
    count(unsafeSysctls) != 0
    name := input.request.object.metadata.name
    msg := sprintf("Pod with containers using unsafe sysctls identified in %v", [name])
}