# PolicyName: PSS - Baseline - Deployment should not run privileged containers
# Description: This admission rule identifies deployments that creates privileged containers


match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Deployment"
    container := input.request.object.spec.template.spec.containers[_]
    container.securityContext.privileged == true
    name := input.request.object.metadata.name
    msg := sprintf("Deployment with Privileged containers created in: %v",[name])
}