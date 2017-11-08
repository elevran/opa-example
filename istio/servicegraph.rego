package servicegraph

import data.service_graph

default allow = false

allow {
    input.external = true
    input.target = "landing_page"
}

allow {
    allowed_targets = service_graph[input.source]
    input.target = allowed_targets[_]
}
