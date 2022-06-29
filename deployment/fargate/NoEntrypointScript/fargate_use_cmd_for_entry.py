#!/usr/bin/env python
import sys
import logging
import json
import docker


def inspect_image(docker_image):
    client = docker.APIClient()
    try:
        data = client.inspect_image(docker_image)
    except docker.errors.ImageNotFound:
        logging.error(f'ERROR: Image on found locally. Try `docker pull {docker_image}`')
        sys.exit(1)
    return data

def print_exec_params(docker_data):
    if not docker_data.get("Config", {}).get("Entrypoint"):
        entrypoint = docker_data.get("Config", {}).get("Cmd")
        cmd = None
    else:
        entrypoint = docker_data.get("Config", {}).get("Entrypoint")
        cmd = docker_data.get("Config", {}).get("Cmd")

    exec_params = {
        "entryPoint": entrypoint,
        "command": cmd
    }
    print(json.dumps(exec_params, indent=4))

if __name__ == "__main__":
    docker_image = sys.argv[1]
    docker_data = inspect_image(docker_image)
    print_exec_params(docker_data)
