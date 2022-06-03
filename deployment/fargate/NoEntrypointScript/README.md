# About
This is some proof of concept code to be used to build a CI/CD pipeline action to derive the Entrypoint and CMD of a given docker image. If no Entrypoint is found either `/bin/sh -c` or the CMD output is used, depending on the script.

# Why?
When creating Fargate Tasks, it is sometimes necessary to explicitly add a EntryPoint. This code offers two solutions: Use `/bin/sh -c` or use the CMD output.

# Requirements
The `docker` python library must be installed

```
pip install -r requirements.txt
```

This script assumes that the image being passed is already on the system, as it would be as part of a build pipeline.

# Usage
`python fargate_use_sh_for_entry.py [Docker Image]`

# Example:
```
$ python get_exec_params.py timekillerj/twistlock-fargate
{
    "EntryPoint": [
        "/bin/sh",
        "-c"
    ],
    "Command": [
        "entry.sh"
    ]
}
```