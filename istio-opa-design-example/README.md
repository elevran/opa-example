# Istio Authorization with Open Policy Agent

The data and policies are based on the advanced policy example (Appendix 2) in [Istio Authorization with Open Policy Agent](https://docs.google.com/document/d/1U2XFmah7tYdmC5lWkk3D43VMAAQ0xkBatKmohf90ICA)

## Using Organizational Chart Data and Policies

Start the OPA REPL with the orgchart data and policy files:

```sh
opa run orgchart.json orgchart.rego
```

- Dump the organizational chart data (JSON object named `employees`)

```prolog
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

- Check if Bob can read Alice's review

```prolog
> true = data.orgchart.allow with input as { "path": [ "reviews", "bob"], "user": "alice" }
false
```

- Check if Bob can read his own review

```prolog
> true = data.orgchart.allow with input as { "path": [ "reviews", "bob"], "user": "bob" }
true
```

- Check if Janet (Bob's manager) can read Bob's review

```prolog
> true = data.orgchart.allow with input as { "path": [ "reviews", "bob"], "user": "janet" }
true
```

- Check if Bob can read Janet's review

```prolog
> true = data.orgchart.allow with input as { "path": [ "reviews", "janet"], "user": "bob" }
false
```

## Using Service Graph Data and Policies

Start the OPA REPL with the service-graph data and policy files:

```sh
opa run servicegraph.json servicegraph.rego
```

- Dump service graph data

```prolog
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

- Check if request from the outside can reach `landing_page`

```prolog
> true = data.servicegraph.allow with input as
{ "source": "some_external_source", "external" : true, "target": "landing_page" }
true
```

- Check if request from the outside can reach `details`

```prolog
> true = data.servicegraph.allow with input as
{ "source": "some_external_source", "external" : true, "target": "details" }
false
```

- Check if request from `landing_page` can reach `ratings`

```prolog
> true = data.servicegraph.allow with input as
{ "source": "landing_page", "external" : false, "target": "ratings" }
false
```

- Check if request from `reviews` can reach `ratings`

```prolog
> true = data.servicegraph.allow with input as
{ "source": "reviews", "external" : false, "target": "ratings" }
true
```

## Using Top-level Policy

Start the OPA REPL with all data and policy files:

`./opa run *.json *.rego`

- Check if Janet can view Bob's review, arriving from `landing_page`

```prolog
> true = data.toplevel.allow with input as
{ "source": "landing_page", "external" : false, "target": "reviews", "path": [ "reviews", "bob"], "user": "janet" }
false
```

- Check if Janet can view Bob's review, arriving from `ratings`

```prolog
> true = data.toplevel.allow with input as
{ "source": "ratings", "external" : false, "target": "reviews", "path": [ "reviews", "bob"], "user": "janet" }
false
```

- Check if Alice can view Bob's review, arriving from `landing_page`

```prolog
> true = data.toplevel.allow with input as
{ "source": "landing_page", "external" : false, "target": "reviews", "path": [ "reviews", "bob"], "user": "alice" }
false
```

### Processing Top-level Policy Using a Request Batch

- Check which requests, in [requestsbatch.json](https://github.com/elevran/opa-example/blob/master/istio-opa-design-example/requestsbatch.json) batch, are allowed

- Show identifiers of allowed requests

```prolog
> data.toplevel.allowed[id]
+----+
| id |
+----+
| 0  |
| 3  |
+----+
```

- Show allowed requests

```prolog
> { data.toplevel.allowed[id], data.requests[id] }
+----+-------------------------------------------------------------------------------------+
| id |                   {data.toplevel.allowed[id], data.requests[id]}                    |
+----+-------------------------------------------------------------------------------------+
| 0  | [{"external":false,"id":0,"path":["reviews","bob"],"source":"landing_page","targ... |
| 3  | [{"external":false,"id":3,"path":["reviews","bob"],"source":"landing_page","targ... |
+----+-------------------------------------------------------------------------------------+
```