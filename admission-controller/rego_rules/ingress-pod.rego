# PolicyName: PSS - Baseline - Kubernetes Ingress without HTTPS traffic
# Description: This admission rules identifies Ingress that allows traffic other than https protocol

match[{"msg": msg}] {
	input.request.operation == "CREATE"
    input.request.kind.kind == "Ingress"
    not input.request.object.spec.tls
    name := input.request.object.metadata.name
    msg := sprintf("Ingress with HTTP Traffic created for: %v",[name])
}