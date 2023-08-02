# PolicyName: PSS - Baseline - Pod that allows containers to share the host network namespace
# Description: This admission rule identifies Pods that allow containers to share the host network namespace

match[{"msg": msg}] {
	input.request.operation == "CREATE"  
	input.request.kind.kind == "Pod"
    input.request.object.spec.hostNetwork == true
    name := input.request.object.metadata.name
    msg := sprintf("Pod with container sharing host network namespace is identified in %v",[name])
}