# PolicyName:  PSS - Baseline - DaemonSet that run containers using HostPath volumes
# Description: This admission rule identifies DaemonSets that run containers using HostPath volumes

match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "DaemonSet"
	volume := input.request.object.spec.template.spec.volumes[_]
    volume.hostPath
    name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with Host Path volume identified in %v",[name])
}