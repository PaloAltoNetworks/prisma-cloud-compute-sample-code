# PolicyName: PSS - Baseline - StatefulSet that allows containers to share the host network namespace
# Description: This admission rule identifies StatefulSets that allow containers to share the host network namespace

match[{"msg": msg}] {
	input.request.operation == "CREATE"    
	input.request.kind.kind == "StatefulSet"
    input.request.object.spec.template.spec.hostNetwork == true
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with container sharing host network namespace is identified in %v",[name])
}