package example_policy

#import data.requests
#import data.

# default: deny all
default allow = false

# allow request if it is inside the same namespce ...
allow {
      all_communication_inside_same_namespace  # source and destination pods are in the same namespace
}

# ... or coming from ingress to a service API pod ...
allow {
      ingress_to_any_service_api  # source is `ingress` and destination has label `role` with value `api`
}

# ... or specifically allowed ...
allow {
      tuples.allow  # specifically allowed tuples  
}

all_communication_inside_same_namespace {
    services[request.src.service].namespace = services[request.dst.service].namespace 
}

ingress_to_any_service_api {
    request.src.service = external
    services[request.dst.service].labels.role = "api"
}