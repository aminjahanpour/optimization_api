import numpy as np
import requests
import json
import gzip

def obj_fun(x):
    # example objective function (replace with your own)
    # Optoria works with 0<=x<=1; you will have to denormalize the x before evaluation
    return x[0] + 2*x[1]

server = 'http://45.32.213.42'
key = 'fake_key'
dim = 2
budget = 200 * dim
id = 'python_example'

resp = requests.post(url='%s?key=%s&req=del&id=%s' % (server, key, id));                                    print(resp.content)
resp = requests.post(url='%s?key=%s&req=create&id=%s&dim=%s&budget=%s' % (server, key, id, dim, budget));   print(resp.content)
resp = requests.post(url='%s?key=%s&req=ask&id=%s' % (server, key, id));                                    print(resp.content)

# arbitrary values for f_best
f_best = 10e20
while b'budget_used_up' not in resp.content:
    dv = json.loads(resp.content.decode("utf-8"))["dv"]
    # creating the vector of objective functions from recoeved solutions
    f = np.array(list(map(obj_fun, dv)))
    # updating the best objective function (for logging only)
    if min(f) <= f_best: #update f_best and x_best
        f_best = min(f)
        x_best = dv[list(f).index(min(f))]
        print("x_best: %s     f_best:%f" % (x_best, f_best))
    # creating a string of evaluated objective function values
    f_arrstr = np.char.mod('%f', f)
    f_string = ",".join(f_arrstr)
    # submitting the objective function values to the server and requesting for new solutions
    payload = {'req': 'roll', 'key': key, 'id': id, 'dim': dim, 'f': gzip.compress(f_string.encode('latin')).decode('latin')}
    resp = requests.post(url=server, json=payload)


