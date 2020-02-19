import numpy as np
import requests
import json
from math import cos, pi, exp, e, sqrt, sin

"""
This is the Ackley test function with -15. < x < 30.
Replace with your own cost function and update the bounds accordingly
"""
def obj_fun(individual, lower_bound=-15., upper_bound=30.):
    # this line is necessary to denormalize the decision variables
    individual = [x * (upper_bound - lower_bound) + lower_bound for x in individual]

    N = len(individual)
    return 20 - 20 * exp(-0.2 * sqrt(1.0 / N * sum(x ** 2 for x in individual))) \
           + e - exp(1.0 / N * sum(cos(2 * pi * x) for x in individual))


server = 'http://45.32.158.25/'

key = 'email mjahanpo@uwaterloo.ca for a key'

dim = 10
budget = 2000
id = 'ackley'

resp = requests.post(url='%s?key=%s&req=del&id=%s' % (server, key, id))
print(resp.content)

resp = requests.post(url='%s?key=%s&req=create&id=%s&dim=%s&budget=%s' % (server, key, id, dim, budget))
print(resp.content)

resp = requests.post(url='%s?key=%s&req=ask&id=%s' % (server, key, id))


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
    payload = {'req': 'roll',
               'key': key,
               'id': id,
               'dim': dim,
               'f': f_string
               }

    resp = requests.post(url=server, json=payload)

print("---------\nbest_found dv: %s" % x_best)
print("best found objective function: %s" % f_best)


