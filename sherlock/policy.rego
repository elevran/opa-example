package sherlock

#import data.requests
#import data.

# default: deny all
default allow = false

# allow request if it is inside the same namespce ...
allow {
      services[request.src.service].namespace = services[request.dst.service].namespace
}

# ... or coming from ingress to a service API pod (based on labels) ...
allow {
    request.src.service = external
    services[request.dst.service].labels.ingress = "api"
}

# ... or specifically allowed ...
allow {
      explicit.allow  # specifically allowed tuples  
}
