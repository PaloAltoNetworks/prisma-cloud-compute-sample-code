# PolicyName:  PSS - Baseline - StatefulSets that run containers using HostPath volumes
# Description: This admission rule identifies StatefulSets that run containers using HostPath volumes

match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
	volume := input.request.object.spec.template.spec.volumes[_]
    volume.hostPath
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with Host Path volume identified in %v",[name])
}