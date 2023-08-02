# PolicyName: PSS - Baseline - Deployment with containers that share host process ID(hostPID) namespace
# Description: This admission rule identifies Deployments that run containers that share host process ID namespace

match[{"msg": msg}] {
    input.request.operation == "CREATE"   
	input.request.kind.kind == "Deployment"
    input.request.object.spec.template.spec.hostPID == true
    name := input.request.object.metadata.name
    msg := sprintf("Deployment with container sharing host process ID(hostPID) is identified in %v",[name])
}