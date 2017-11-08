package service_policy

import data.services

# default: deny all
default allow = false

# allow request if it is inside the same namespce ...
allow {    
    valid_service_account[input.src]
    valid_service_account[input.dst]
    source = services[_]
    source.sa = input.src
    destination = services[_]
    destination.sa = input.dst
    source.ns = destination.ns
}

# ... coming from ingress to a service API pod (based on having labels: {"ingress":true, "role":"api"}) ...
allow {
    input.src = "external"
    valid_service_account[input.dst]
    destination = services[_]
    destination.sa = input.dst
    destination.labels.ingress = true
    destination.labels.role = "api"
}

# ... or cross namespace if destination is labeled as "api"
allow {    
    valid_service_account[input.src]
    valid_service_account[input.dst]
    source = services[_]
    source.sa = input.src
    destination = services[_]
    destination.sa = input.dst
    source.ns != destination.ns
    destination.labels.role = "api"
}

# helper: a request service is valid if there exists a service with the given service-account (sa)
valid_service_account[sa] {
    sa = services[_].sa
}