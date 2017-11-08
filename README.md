# OPA Example for Controlling Microservice Communication

Experimenting with [open policy agent](https://github.com/open-policy-agent/opa)

## Prerequisite

Download the OPA interactive shell (a.k.a. REPL), for your platform, from the [OPA github releases page](https://github.com/open-policy-agent/opa/releases/).
For example, downloading release 0.5.10 for 64-bit Linux:

``` sh
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.5.10/opa_linux_amd64 \
    && chmod 755 ./opa
```

Make sure you can run (`./opa run`) and quit (<kbd>Ctrl-D</kbd> or `exit`) the REPL.

## Experiments

The repository includes two experiments:

- [istio-opa-design-example](https://github.com/elevran/opa-example/blob/master/istio-opa-design-example/README.md) - A policy definition based on the [Istio OPA adapter design](https://docs.google.com/document/d/1U2XFmah7tYdmC5lWkk3D43VMAAQ0xkBatKmohf90ICA)
- [Sherlock](https://github.com/elevran/opa-example/blob/master/sherlock/README.md) - a fictional microservice based service, loosely based on [Istio Bookinfo](https://istio.io/docs/guides/bookinfo.html) application

## Out of Scope - Policy Control

In addition to the actual network isolation policies, there may exist requirements on who can define policies for each service,
 and whether policies, or specific rules and condition defined within a policy, defined by one role (e.g., CISO or other security personnel) can be overridden by service teams (e.g., DevOps engineers)

- Policy control (who can define policies, which can be overridden, etc.)
- Policy processing in case of multiple policies applied to an operation (e.g., priority, conflict resolution)

While it may be possible to resolve the above using OPA and [Rego](http://www.openpolicyagent.org/docs/language-reference.html), this work is beyond the scope of this experiment.