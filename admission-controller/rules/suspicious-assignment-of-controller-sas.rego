# Catch suspicious assigment of powerful, pre-installed controller service accounts to pods.
operations = {"CREATE", "UPDATE"}
match[{"msg": msg, "details": {}}] {
    operations[input.request.operation]
    podSpec := getPodSpec(input.request.object)
    sa := podSpec.serviceAccountName
    ns := input.request.object.metadata.namespace
    isControllerSA(sa, ns)
    msg := sprintf("Assignment of controller service account '%v:%v' to a pod", [ns, sa])
}

isControllerSA(sa, ns) {
    forbiddenSA := controllerSAs[_]
    sa == forbiddenSA["name"]
    ns == forbiddenSA["namespace"]
}

getPodSpec(obj) = spec {
    obj.kind == "Pod"
    spec := obj.spec
} {
    obj.kind == "CronJob"
    spec := obj.spec.jobTemplate.spec.template.spec
} {
    obj.kind == "ReplicaSet"
    spec := obj.spec.template.spec
} {
    obj.kind == "ReplicationController"
    spec := obj.spec.template.spec
} {
    obj.kind == "Deployment"
    spec := obj.spec.template.spec
} {
    obj.kind == "StatefulSet"
    spec := obj.spec.template.spec
} {
    obj.kind == "DaemonSet"
    spec := obj.spec.template.spec
} {
    obj.kind == "Job"
    spec := obj.spec.template.spec
}


# Not every controller SA is powerful, but there's no reason 
# for either of them to be assigned to a pod
controllerSAs := [
    {
        "name": "attachdetach-controller",
        "namespace": "kube-system",
    },
    {
        "name": "certificate-controller",
        "namespace": "kube-system",
    },
    {
        "name": "clusterrole-aggregation-controller",
        "namespace": "kube-system",
    },
    {
        "name": "cronjob-controller",
        "namespace": "kube-system",
    },
    {
        "name": "daemon-set-controller",
        "namespace": "kube-system",
    },
    {
        "name": "deployment-controller",
        "namespace": "kube-system",
    },
    {
        "name": "disruption-controller",
        "namespace": "kube-system",
    },
    {
        "name": "endpoints-controller",
        "namespace": "kube-system",
    },
    {
        "name": "endpointslice-controller",
        "namespace": "kube-system",
    },
    {
        "name": "ephermal-volume-controller",
        "namespace": "kube-system",
    },
     {
        "name": "expand-controller",
        "namespace": "kube-system",
    },
    {
        "name": "job-controller",
        "namespace": "kube-system",
    },
    {
        "name": "namespace-controller",
        "namespace": "kube-system",
    },
    {
        "name": "node-controller",
        "namespace": "kube-system",
    },
    {
        "name": "pod-garbage-controller",
        "namespace": "kube-system",
    },
    {
        "name": "pv-protection-controller",
        "namespace": "kube-system",
    },
    {
        "name": "pvc-protection-controller",
        "namespace": "kube-system",
    },
    {
        "name": "pvc-protection-controller",
        "namespace": "kube-system",
    },
    {
        "name": "replicaset-controller",
        "namespace": "kube-system",
    },
    {
        "name": "replication-controller",
        "namespace": "kube-system",
    },
    {
        "name": "resourcequota-controller",
        "namespace": "kube-system",
    },
    {
        "name": "service-account-controller",
        "namespace": "kube-system",
    },
    {
        "name": "service-controller",
        "namespace": "kube-system",
    },
    {
        "name": "statefulset-controller",
        "namespace": "kube-system",
    },
    {
        "name": "ttl-after-finished-controller",
        "namespace": "kube-system",
    },
    {
        "name": "ttl-controller",
        "namespace": "kube-system",
    },
    {
        "name": "vpc-resource-controller",
        "namespace": "kube-system",
    }
]