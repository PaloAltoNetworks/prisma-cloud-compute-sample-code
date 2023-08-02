# PolicyName: PSS - Baseline - DaemonSet with containers that share host process ID(hostPID) namespace
# Description: This admission rule identifies DaemonSets that run containers that share host process ID namespace

match[{"msg": msg}] {   
    input.request.operation == "CREATE"   
	input.request.kind.kind == "DaemonSet"
    input.request.object.spec.template.spec.hostPID == true
    name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with container sharing host process ID(hostPID) is identified in %v",[name])
}