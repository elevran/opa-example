package toplevel

import data.requests

allowed[requestid] {
   request = requests[_]
   requestid = request.id
   true = data.toplevel.allow with input as request
}
