# PolicyName: PSS - Baseline - StatefulSet with container that share host IPC namespace
# Description: This admission rule identifies StatefulSets that run containers that share host IPC namespace

match[{"msg": msg}] {
    input.request.operation == "CREATE"   
	input.request.kind.kind == "StatefulSet"
    input.request.object.spec.template.spec.hostIPC == true
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with container sharing host IPC is identified in %v",[name])
}