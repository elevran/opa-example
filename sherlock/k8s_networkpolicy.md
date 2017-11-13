# Using Kubernetes Network Policies

## Introduction

A network policy is a specification of how groups of pods are allowed to communicate with each other and other network endpoints.

By default, pods are non-isolated; they accept traffic from any source. `NetworkPolicy` resources use labels to select pods and define rules which specify what traffic is allowed to the selected pods. Once pods become isolated (i.e., have a NetworkPolicy that selects them), that pod will reject any connections that are not allowed by any NetworkPolicy. Other pods in the namespace that are not selected by any NetworkPolicy will continue to accept all traffic.

Network policies are implemented by a network plugin, so this requires a Kubernetes cluster using a networking solution which supports `NetworkPolicy` (e.g., Calico, Cilium, WeaveNet, etc.)

## Using `NetworkPolicy` Resource

See the [api-reference](/docs/api-reference/{{page.version}}/#networkpolicy-v1-networking) for a full definition of the resource.

Like all Kubernetes objects a `NetworkPolicy` object has `metadata` (e.g., name, namespace) and a `spec`.
 The `spec` defines a selector and one or more ingress or egress policies for pods selected by it. Thus, the object has all of the information required to define a particular network policy _in a given namespace_.

### Default Deny All

A "default" isolation policy for a namespace is achieved with a NetworkPolicy that selects all pods but does not allow any ingress or egress traffic to those pods. This ensures that even pods that aren't selected by any other NetworkPolicy will still be isolated.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### Same Namespace

A policy to allow communicating between all pods in namespace `ns1`, might look like this:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ns1-network-policy
  namespace: ns1
spec:
  podSelector:
    matchLabels: {}
  namespaceSelector:
    matchLabel:
      name: ns1
  policyTypes:
  - Ingress: {}
  - Egress: {}
```

Note that we need an explicit `NetworkPolicy` for each namespace and a well defined label for each namespace (since the namespace selector refers to labels, not the namespace name...)

## Access to API Endpoints

A policy to allow communicating to API endpoint in `ns1`, might look like this:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ns1-api-network-policy
  namespace: ns1
spec:
  podSelector:
    matchLabels:
      role: api
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector: {}
```

To address Ingress policy requirements (external traffic via ingress to API pods), a similar policy can be defined for pods with additional matchLabel of `ingress=true`.

Note that here too we would require a policy per namespace.