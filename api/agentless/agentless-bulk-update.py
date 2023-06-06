# Some setup for a python virtual environment 
# python3 -m venv env
# source env/bin/activate
# pip install requests

import requests

#Set Credentials
console_url   = ""
access_key     = ""
secret_key    = ""

payload = {
    'username':access_key,
    'password':secret_key
}

#Generate a Token for access to Prisma Cloud Compute. 
TOKEN = requests.post(console_url+"/api/v1/authenticate", json=payload).json()['token']

#Set Prisma Cloud Headers for Login with token
pccHeaders = {
    'Authorization': 'Bearer '+TOKEN,
    'Accept': 'application/json'
}
limit = 50
offset = 0
response = True

while response:

    payload = {
        'limit':limit,
        'offset':offset,
        #'cloudProviders':"gcp"
    }
    
    response = requests.get(console_url+"/api/v1/cloud-scan-rules", headers=pccHeaders, params=payload).json()
    offset=offset+limit

    if response:
        for i in response:
            credential = i["credentialId"]
            hub_account = ""
            regions = ""
            if "hubCredentialID" in i["agentlessScanSpec"]:
                hub_account = i["agentlessScanSpec"]["hubCredentialID"]
            if "regions" in i["agentlessScanSpec"]:
                regions = i["agentlessScanSpec"]["regions"]
            print(credential," --- ",hub_account," --- ",regions)
            del i["modified"]
            del i["credential"]
            del i["agentlessScanSpec"]["accountState"]


            i["agentlessScanSpec"]["hubCredentialID"] = ""

            #i["agentlessScanSpec"]["regions"] = ["us-east1", "us-central1"]
            i["agentlessScanSpec"]["regions"] = ["us-east4"]
            i["agentlessScanSpec"]["autoScale"] = True
            i["agentlessScanSpec"]["scanners"] = 1
            i["agentlessScanSpec"]["subnet"] = ""

            data=[]
            data.append(i)
            print(data)
            update = requests.put(console_url+"/api/v1/cloud-scan-rules", headers=pccHeaders, json=data)
            print(update)


