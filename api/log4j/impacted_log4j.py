
import json
import os
import requests
from re import search

def getData(base_url, token, image_id = None):
    CVE="CVE-2021-44228"

    url = "https://%s/api/v1/stats/vulnerabilities/impacted-resources?cve=%s" % ( base_url ,CVE)

    headers = {"content-type": "application/json; charset=UTF-8", 'Authorization': 'Bearer ' + token }    
    response = requests.get(url, headers=headers)

    items = response.json()
    
    if items:
        for item in items["riskTree"]:
            image=items["riskTree"][item]
            for i in image:
                #print(i)
                print("Image={};Container={};Host={};".format(i["image"],i["container"],i["host"]))
       

def login(base_url, access_key, secret_key): 
    url = "https://%s/api/v1/authenticate" % ( base_url )

    payload = json.dumps({
        "username": access_key,
        "password": secret_key
    })
    headers = {"content-type": "application/json; charset=UTF-8"}    
    response = requests.post(url, headers=headers, data=payload)
    return response.json()["token"]

def getParamFromJson(config_file):
    f = open(config_file,)
    params = json.load(f)
    pcc_api_endpoint = params["pcc_api_endpoint"]
    access_key_id = params["access_key_id"]
    secret_key = params["secret_key"]
    # Closing file
    f.close()
    return pcc_api_endpoint, access_key_id, secret_key;

def main():    
    CONFIG_FILE= os.environ['HOME'] + "/.prismacloud/credentials.json"
    PCC_API_ENDPOINT, ACCESS_KEY_ID, SECRET_KEY = getParamFromJson(CONFIG_FILE)
    token = login(PCC_API_ENDPOINT, ACCESS_KEY_ID, SECRET_KEY)
    
    getData(PCC_API_ENDPOINT, token)

if __name__ == "__main__":
    main()