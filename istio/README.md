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

## Examples

### Orgchart
`./opa run orgchart.json orgchart.rego`

* dump employee data
```
> data.employees
{
  "alice": {
    "manager": "janet",
    "roles": [
      "engineering"
    ]
  },
  "bob": {
    "manager": "janet",
    "roles": [
      "engineering"
    ]
  },
  "janet": {
    "roles": [
      "engineering"
    ]
  },
  "ken": {
    "roles": [
      "hr"
    ]
  }
}
```
* check if Bob can read the review of Alice
```
> true = data.orgchart.allow with input as { "path": [ "reviews", "bob"], "user": "alice" }
false
```
* check if Bob can read the review of himself
```
> true = data.orgchart.allow with input as { "path": [ "reviews", "bob"], "user": "bob" }
true
```
* check if Janet (Bob's manager) can read the review of Bob
```
> true = data.orgchart.allow with input as { "path": [ "reviews", "bob"], "user": "janet" }
true
```
* check if Bob can read the review of Janet
```
> true = data.orgchart.allow with input as { "path": [ "reviews", "janet"], "user": "bob" }
false
```

### Servicegraph
`./opa run servicegraph.json servicegraph.rego`

* dump service graph data
```
> data.service_graph
{
  "landing_page": [
    "details",
    "reviews"
  ],
  "reviews": [
    "ratings"
  ]
}
```

* check if request from the outside can reach `landing_page`
```
> true = data.servicegraph.allow with input as { "source": "some_external_source", "external" : true, "target":"landing_page" }
true
```
* check if request from the outside can reach `details`
```
> true = data.servicegraph.allow with input as { "source": "some_external_source", "external" : true, "target":"details" }
false
```

* check if request from `landing_page` can reach `ratings`
```
> true = data.servicegraph.allow with input as { "source": "landing_page", "external" : false, "target": "ratings" }
false
```

* check if request from `reviews` can reach `ratings`
```
> true = data.servicegraph.allow with input as { "source": "reviews", "external" : false, "target": "ratings" }
true
```
