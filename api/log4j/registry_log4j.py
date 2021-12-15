
import json
import os
import requests
from re import search

def getData(base_url, token, image_id = None):

    url = "https://%s/api/v1/registry?limit=0" % ( base_url )

    headers = {"content-type": "application/json; charset=UTF-8", 'Authorization': 'Bearer ' + token }    
    response = requests.get(url, headers=headers)
    totalCount=response.headers["Total-Count"]
    print("Total Images in Registry = {}".format(totalCount) )
    
    CVE="CVE-2021-44228"
    regex="log4j"
    offset=0
    limit=50
    items = True


    while items:

        url = "https://%s/api/v1/registry?limit=%s&offset=%s" % ( base_url,limit,offset )
        print(url)
        offset=offset+limit
        response = requests.get(url, headers=headers)
        
        items = response.json()
        
        if items:
            
            for image in items:
                if image["vulnerabilities"] != None:
                    for vulns in image["vulnerabilities"]:
                        if vulns["cve"] == CVE:
                            print("Image={}".format(image['instances'][0]['image']) )
                            for packags in image["packages"]:
                                for pkgs in packags["pkgs"]:
                                    if "path" in pkgs and regex in pkgs["path"]:
                                        print("Path={};Version={};".format(pkgs["path"],pkgs["version"]))

                    
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