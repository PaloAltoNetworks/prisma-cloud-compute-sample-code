# PolicyName: PSS - Baseline - DaemonSet with containers that using images from unauthorized registries
# Description: This policy identifies DaemonSets with containers using images from unauthorized registries

# In the below set, add allowed registry sources as needed
allowed_sources := {"registry.example.com"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "DaemonSet"
    image := input.request.object.spec.template.spec.containers[_].image
    images := {i | i := split(image, "/")[0]}
    compliant_images := images - allowed_sources
    count(compliant_images) != 0
    name := input.request.object.metadata.name
    msg := sprintf("DaemonSet with container using images from unauthorized registry found in:: %v", [name])
    
}