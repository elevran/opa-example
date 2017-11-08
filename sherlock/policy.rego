package sherlock

#import data.requests
#import data.

# default: deny all
default allow = false

# allow request if it is inside the same namespce ...
allow {
      services[request.src].namespace = services[request.dst].namespace
}

# ... or coming from ingress to a service API pod (based on labels: {"ingress":true, "role":"api") ...
allow {
    request.src.service = external
    services[request.dst].labels.ingress = true
    services[request.dst].labels.role = "api"
}
