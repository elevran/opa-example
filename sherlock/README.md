## Policy Overview

Define a basic service and namespace communication isolation policy (i.e., micro-segmentation).
The policy assumes that each service:

1. runs in its own namespace
1. can optionally be exposed via an Ingress
1. any interaction (ingress or inter-service) must go through specified service API endpoints (e.g., pods labeled `role=api`, by convention)

Thus, the policy can be expressed as:

- default: deny
- allow: source and destination pods are in the same namespace
- allow: source is `ingress` and destination has label `role` with value `api` and label `ingress` with value `true`
- allow: source is not `ingress` and destination has label `role` with value `api`
- allow: specific tuple {service 'foo' to service-'bar'}

### Experiment

- The policy document includes
- The requests document includes

To run the experiment, load both documents into the OPA REPL: ``.

### RBAC Based Implementation

An RBAC policy is composed of two parts:

- a `Role` definition assigns _permissions_ (e.g., resources, methods) to a _name_
- a `Role-Binding` definition associates _principles_ (e.g., users, service accounts) with a _Role_ (via its name)

Given the above policy definition, policies for an RBAC based policy engine, could become extremely verbose.
 For example, expressing a policy that allows any two components in the same namespace to communicate, requires a separate policy definition (i.e., Role and Role-Binding) for each and every namespace and all service accounts contained within.