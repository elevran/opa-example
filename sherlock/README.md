## Policy Overview

Define a basic service and namespace communication isolation policy (i.e., micro-segmentation).
The policy assumes that each service:

1. runs in its own namespace
1. can optionally be exposed via an Ingress
1. any interaction (ingress or inter-service) must go through specified service API endpoints (e.g., pods labeled `role=api`, by convention)

Thus, the policy can be expressed as:

- default: deny
- allow: source and destination pods are in the same namespace
- allow: source is `external` (i.e. via ingress) and destination has labels `role=api` and label `ingress=true`
- allow: source is not `external` and destination has label `role` with value `api`
- allow: specific tuple {service 'foo' to service 'bar'}, optionally setting access to read-only

### RBAC Based Implementation

An RBAC policy is composed of two parts:

- a `Role` definition assigns _permissions_ (e.g., resources, methods) to a _name_
- a `Role-Binding` definition associates _principles_ (e.g., users, service accounts) with a _Role_ (via its name)

Given the above policy definition, policies for an RBAC based policy engine, could become extremely verbose.
 For example, expressing a policy that allows any two components in the same namespace to communicate, requires a separate policy definition (i.e., Role and Role-Binding) for each and every namespace and all service accounts contained within.

## Experiment

To run the experiment, load both documents into the OPA REPL: ``.

```sh
opa services.* explicit.*
```

- the `services.json` file defines the application services. Such data would typically come from an orchestrator, such as
 Kubernetes. For each service, it includes the service name, namespace, labels and a service-account would is used to identify the service in requests
- the `services.rego` policy defines the same-namespace constraint, the ingress constraints and the access to service API endpoint constraints.
- requests are encoded as JSON object with the below format:

```json
{
    "desc": "description string",
    "src": "source service account",
    "dst": "destination service account",
    "method": "HTTP method name",
    "url": "request URL"
}
```

- Show all valid service accounts

```prolog
> > data.service_policy.valid_service_account
[
  "ingress/ingress",
  "ingress/login",
  "storefront/fe",
  "storefront/details",
  "reviews/reviews",
  "reviews/ratings",
  "reviews/ratings",
  "userdb/users",
  "userdb/users"
]
```

### Ingress Policy

Note that only attributes that are relevant to the specific policy are encoded.

```prolog
> data.service_policy.allow with input as { "src": "external", "dst": "ingress/ingress" }
true
> data.service_policy.allow with input as { "src": "external", "dst": "storefront/fe" }
true
> data.service_policy.allow with input as { "src": "external", "dst": "ingress/login" }
false
```

### Same Namespace Policy

Note that only attributes that are relevant to the specific policy are encoded.

```prolog
> data.service_policy.allow with input as { "src": "ingress/ingress", "dst": "ingress/login" }
true
> data.service_policy.allow with input as { "src": "default/doesnt-exist", "dst": "ingress/login" }
false
> data.service_policy.allow with input as { "src": "reviews/ratings", "dst": "reviews/reviews" }
true
```

### Cross Namespace to Service API Endpoints

Note that only attributes that are relevant to the specific policy are encoded.

```prolog
> data.service_policy.allow with input as { "src": "reviews/ratings", "dst": "userdb/users" }
true
> data.service_policy.allow with input as { "src": "reviews/ratings", "dst": "userdb/mysql" }
false
```

### Explicitly Allowed

```prolog
> data.explicit_link.allow
false
> data.explicit
[
  {
    "dst": "userdb/mysql",
    "readonly": true,
    "src": "ingress/login"
  }
]
> data.explicit_link.allow with input as { "src": "ingress/login", "dst": "userdb/mysql", "method": "GET"}
true
> data.explicit_link.allow with input as { "src": "ingress/login", "dst": "userdb/mysql", "method": "PUT"}
false
```