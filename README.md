# opa-example for controlling microservice communication

Experimenting with [open policy agent](https://github.com/open-policy-agent/opa)

## Prerequisite

Download the OPA interactive shell (a.k.a. REPL), for your platform, from the [OPA github releases page](https://github.com/open-policy-agent/opa/releases/).
For example, downloading release 0.5.10 for 64-bit Linux:

``` sh
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.5.10/opa_linux_amd64 \
    && chmod 755 ./opa
```

Make sure you can run (`./opa run`) and quit (<kbd>Ctrl-D</kbd> or `exit`) the REPL.

## Policy Overview

Define a basic service and namespace communication isolation policy (i.e., micro-segmentation).
The policy assumes that each service:

1. runs in its own namespace
1. can optionally be exposed via an Ingress
1. any interaction (ingress or inter-service) must go through specified service API endpoints (e.g., pods labeled `role=api`, by convention)

Thus, the policy can be expressed as:

- default: deny
- allow: source and destination pods are in the same namespace
- allow: source is `ingress` and destination has label `role` with value `api`
- allow: specific tuple {ns1:svc1, ns2:api}

### Experiment

The experiment uses a single policy document and a json file containing sample requests, aptly named `policy.rego` and `requests.json`.

- The policy document includes
- The requests document includes

To run the experiment, load both documents into the OPA REPL: ``.

## Policy Control

In addition, there may exist requirements on who can define policies for each service, and whether policies, or specific rules and condition defined within a policy, defined by one role (e.g., CISO or other security personnel) can be overridden by service teams (e.g., DevOps engineers)

- Policy control (who can define policies, which can be overridden, etc.)
- Policy processing in case of multiple policies applied to an operation (e.g., priority, conflict resolution)

While it may be possible to resolve the above using OPA and [Rego](http://www.openpolicyagent.org/docs/language-reference.html), this work is beyond the scope of this experiment.

## RBAC Based Implementation

An RBAC policy is composed of two parts:

- a `Role` definition assigns _permissions_ (e.g., resources, methods) to a _name_
- a `Role-Binding` definition associates _principles_ (e.g., users, service accounts) with a _Role_ (via its name)

Given the above policy definition, policies for an RBAC based policy engine, could become extremely verbose.
For example, expressing a policy that allows any two components in the same namespace to communicate, requires a separate policy definition (i.e., Role and Role-Binding) for each and every namespace and all service accounts contained within.