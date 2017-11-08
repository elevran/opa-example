package servicegraph

import data.service_graph

default allow = false

# ingress to landing_page
allow {
    input.external = true
    input.target = "landing_page"
}

# explicitly allowed in the service graph information (mapping of source to array of destinations)
allow {
    allowed_targets = service_graph[input.source]
    input.target = allowed_targets[_]
}
