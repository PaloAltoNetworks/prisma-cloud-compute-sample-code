# PolicyName: PSS - Baseline - DaemonSet with container that share host IPC namespace
# Description: This admission rule identifies DaemonSets that run containers that share host IPC namespace

match[{"msg": msg}] {
    input.request.operation == "CREATE"   
	input.request.kind.kind == "DaemonSet"
    input.request.object.spec.template.spec.hostIPC == true
    name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with container sharing host IPC is identified in %v",[name])
}