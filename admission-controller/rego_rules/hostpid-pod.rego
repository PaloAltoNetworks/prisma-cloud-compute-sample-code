# PolicyName: PSS - Baseline - Pod with containers that share host process ID(hostPID) namespace
# Description: This admission rule identifies Pods that run containers that share host process ID namespace

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
	  input.request.object.spec.hostPID == true
    name := input.request.object.metadata.name
    msg := sprintf("Pod with container sharing host process ID(hostPID) is identified in %v",[name])
}