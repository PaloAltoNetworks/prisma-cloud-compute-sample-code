# PolicyName:  PSS - Baseline - Pod created with sensitive host file system mount
# Description: This admission rule identifies Pods with sensitive host file system mount



match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind = "Pod"
	hostPath := input.request.object.spec.volumes[_].hostPath.path
	res := [startswith(hostPath, "/etc"), startswith(hostPath, "/var"), hostPath == "/"]
	res[_]
    name := input.request.object.metadata.name
    msg := sprintf("Pod with Sensitive host file system mount identified in %v",[name])
}