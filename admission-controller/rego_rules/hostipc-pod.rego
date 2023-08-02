# PolicyName: PSS - Baseline - Pod with container that share host IPC namespace
# Description: This admission rule identifies Pods that run containers that share host IPC namespace

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "Pod"
    input.request.object.spec.hostIPC == true
    name := input.request.object.metadata.name
    msg := sprintf("Pod with container sharing host IPC is identified in %v",[name])
}