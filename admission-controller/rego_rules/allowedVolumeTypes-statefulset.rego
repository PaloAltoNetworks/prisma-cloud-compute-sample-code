# PolicyName: PSS - Restricted - StatefulSet with containers that use disallowed volume types
# Description: This policy identifies StatefulSets with containers that use disallowed volume types


# Below are the allowed volume types as mentioned in the Kubernetes documentation
allowedVolumeTypes = {"configMap", "csi", "downwardAPI", "emptyDir","ephemeral","persistentVolumeClaim","projected", "secret"}

match[{"msg": msg}] {
          input.request.operation == "CREATE"
          input.request.kind.kind == "StatefulSet"
          container := input.request.object.spec.template.spec
          volume_fields := {x | container.volumes[_][x]; x != "name"}
          notAllowedVolumes := volume_fields - allowedVolumeTypes
          count(notAllowedVolumes) != 0
          name := input.request.object.metadata.annotations
          msg := sprintf("StatefulSet with containers using disallowed volume types identified in %v", [name])
}