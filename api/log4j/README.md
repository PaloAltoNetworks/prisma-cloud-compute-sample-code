# How to use this script

## Authentication

Create an access key from Settings then Access key  
Get the path to console from Compute tab, System, Utilities  

Create a file into home directory .prismacloud/credentials.json with the following structure  

```json
{
  "pcc_api_endpoint": "__REDACTED__",
  "access_key_id": "__REDACTED__",
  "secret_key": "__REDACTED__"
}
```

## Setup

Create Python virtual environment

```console
cd api/log4j
python3 -m venv env
source env/bin/activate
pip install requests
```


## Run the script

```console
python3 registry_log4j.py
```

It should generate a CSV file with all the licenses per package.