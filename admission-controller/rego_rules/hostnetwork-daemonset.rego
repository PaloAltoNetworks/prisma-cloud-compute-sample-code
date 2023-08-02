# PolicyName: PSS - Baseline - DaemonSet that allows containers to share the host network namespace
# Description: This admission rule identifies DaemonSets that allow containers to share the host network namespace

match[{"msg": msg}] {
	input.request.operation == "CREATE"    
	input.request.kind.kind == "DaemonSet"
    input.request.object.spec.template.spec.hostNetwork == true
    name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with container sharing host network namespace is identified in %v",[name])
}