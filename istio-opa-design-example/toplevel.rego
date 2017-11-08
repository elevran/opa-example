package toplevel

import data.servicegraph
import data.orgchart

# explicitly deny request by default (even though this is implied)
default allow = false

# Allow request if...
allow {
    servicegraph.allow  # service graph policy allows, and...
    orgchart.allow      # org chart policy allows.
}
