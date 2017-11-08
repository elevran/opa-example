package explicit_link

import data.explicit

default allow = false

allow {
    rule = explicit[_]
    input.src = rule.src
    input.dst = rule.dst
    method = upper(input.method)
    permissible_access[[rule, method]]
}

permissible_access[[rule, method]] {
    rule = explicit[_]
    rule.readonly
    is_readonly_method[method]
}

permissible_access[[rule, method]] {
    rule = explicit[_]
    not rule.readonly
    is_http[method]
}

is_http[m] {
    http_methods = { "GET", "HEAD", "POST", "PATCH", "PUT", "DELETE" }
    http_methods[m] = m
}

is_readonly_method[m] {
    readonly_methods = { "GET", "HEAD" }
    readonly_methods[m] = m
}


