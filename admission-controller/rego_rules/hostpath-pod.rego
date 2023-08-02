# PolicyName:  PSS - Baseline - Pod that run containers using HostPath volumes
# Description: This admission rule identifies Pods that run containers using HostPath volumes

match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
	volume := input.request.object.spec.volumes[_]
    volume.hostPath
    name := input.request.object.metadata.name
    msg := sprintf("Pod with Host Path volume identified in %v",[name])
}