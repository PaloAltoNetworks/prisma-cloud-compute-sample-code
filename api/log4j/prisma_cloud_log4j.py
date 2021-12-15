__author__ = "Simon Melotte"

import json
import os
import requests
from re import search

def getLicenses(base_url, token, image_id = None):
    if (image_id):
        url = "https://%s/api/v21.08/registry?id=%s" % ( base_url, image_id )
    else:
        url = "https://%s/api/v21.08/registry" % ( base_url )

    headers = {"content-type": "application/json; charset=UTF-8", 'Authorization': 'Bearer ' + token }    
    response = requests.get(url, headers=headers)
    images = response.json()

    
    csv = open("applications-running-log4j.csv", "w")
    csv.write("Image;Id;Namespace;osDistro;Package;License\n")

    #print(images)

    for image in images:
        for pkgs in image["packages"]:
            for pkg in pkgs["pkgs"]:    
                if ("log4j" in pkg['name']):
                    #csv.write("{};{};{};{};{};{}\n".format(image['instances'][0]['image'], image['_id'], image['namespaces'], image['installedProducts']['osDistro'], pkg['name'], pkg['license']) )
                    #print("Image={}, id={}, Namespace={}, osDistro={}, Package={}, License={}".format(image['instances'][0]['image'], image['_id'], image['namespaces'], image['installedProducts']['osDistro'], pkg['name'], pkg['license']) )
                    print("Image={}".format(image['instances'][0]['image']) )



    csv.close()
                    
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
    getLicenses(PCC_API_ENDPOINT, token)
    #getLicenses(PCC_API_ENDPOINT, token, "sha256:07a2849f2f074010c643bf04305e462515d1b9a3615d578b4365f46a005721e3")

if __name__ == "__main__":
    main()