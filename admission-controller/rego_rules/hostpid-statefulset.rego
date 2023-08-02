# PolicyName: PSS - Baseline - StatefulSet with containers that share host process ID(hostPID) namespace
# Description: This admission rule identifies StatefulSets that run containers that share host process ID namespace

match[{"msg": msg}] { 
    input.request.operation == "CREATE"   
	input.request.kind.kind == "StatefulSet"
    input.request.object.spec.template.spec.hostPID == true
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with container sharing host process ID(hostPID) is identified in %v",[name])
}