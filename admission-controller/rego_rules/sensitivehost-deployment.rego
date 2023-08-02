# PolicyName:  PSS - Baseline - Deployment created with sensitive host file system mount
# Description: This admission rule identifies Deployments with sensitive host file system mount


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind = "Deployment"
	hostPath := input.request.object.spec.template.spec.volumes[_].hostPath.path
	res := [startswith(hostPath, "/etc"), startswith(hostPath, "/var"), hostPath == "/"]
	res[_]
    name := input.request.object.metadata.name
    msg := sprintf("Deployment with Sensitive host file system mount identified in %v",[name])
}