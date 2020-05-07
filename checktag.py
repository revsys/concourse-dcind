#!/usr/bin/env python3

import urllib.request
from urllib.error import HTTPError, URLError
import os
import sys
import json



try:
    REGISTRY = os.environ['DOCKER_REGISTRY']
except KeyError:
    REGISTRY = "registry"


if len(sys.argv) < 3:
    print(f'\nusage: {sys.argv[0]} <image name> <image tag>\n', file=sys.stderr)
    sys.exit(1)

NAME = sys.argv[1]
TAG = sys.argv[2]

try:
    response = urllib.request.urlopen(
        f'http://{REGISTRY}:5000/v2/{NAME}/tags/list'
    )
except HTTPError as e:
    print(
        f'\n{e.filename} returned status code {e.code}: {e.reason}\n',
        file=sys.stderr
    )
    sys.exit(2)
except URLError as e:
    print(
        f'\nerror connecting to host, {REGISTRY}:5000: {e.reason}\n',
        file=sys.stderr
    )
    sys.exit(2)


response_data = json.load(response)

if TAG in response_data['tags']:
    sys.exit(0)
else:
    sys.exit(1)



