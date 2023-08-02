# PolicyName:  PSS - Baseline - Deployment that run containers using HostPath volumes
# Description: This admission rule identifies Deployment that run containers using HostPath volumes

match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Deployment"
	volume := input.request.object.spec.template.spec.volumes[_]
    volume.hostPath
    name := input.request.object.metadata.name
    msg := sprintf("Deployment with Host Path volume identified in %v",[name])
}