# source based on https://developer.byu.edu/docs/consume-api/use-api/oauth-20/oauth-20-python-sample-code
#
__author__ = "Darrell O'Donnell"
__copyright__ = "Copyright 2019, CULedger, LLC"
__credits__ = ["BYU-bdm4"]
__license__ = "BSD-3-Clause"
__version__ = "1.0.1"
__maintainer__ = ""
__status__ = "beta"


import requests, json
import urllib3
import argparse

parser = argparse.ArgumentParser(description='Simple onboarding utility to test CULedger.Identity API.')
parser.add_argument("--m", default="test1234", help="memberId - do NOT use internally signficant identier.")
parser.add_argument("--p", help="10-digit (North American) phone number that will be invited")

args = parser.parse_args()
memberId = args.m
phoneNumber = args.p
print(memberId)
print(phoneNumber)


# disable https warnings
urllib3.disable_warnings()

authorize_url = "https://api.byu.edu/authorize"
token_url = "https://api.byu.edu/token"


#TODO: work in E.164 testing
#


#TODO: MOVE TO CONFIG FILE:
CLIENTID="3160b30a-73c9-49ee-b4c0-bf507f9fdba7"
SECRET="Y/PZC4uQtDAPJspCoikD43z8atB3NfSMbQoNIFNHaXc="
TENANTID="e7b6a690-d322-4085-b6d6-d0a4f70f0d7b"
MEMBERPASS_URL="https://culedger-prod04.culedgerapi.com/CULedger/CULedger.Identity/0.3.0/"
OAUTH_URL="https://login.microsoftonline.com/e7b6a690-d322-4085-b6d6-d0a4f70f0d7b/oauth2/token"


# Get OAuth2 token from Azure AD


data = {'grant_type': 'client_credentials', 'client_secret': SECRET, 'client_id' : CLIENTID, 'redirect_uri': ""}

print("requesting access token")
access_token_response = requests.post(OAUTH_URL, data=data, verify=False, allow_redirects=False)

# SAMPLE OUTPUT:
# {'token_type': 'Bearer', 'expires_in': '3599', 'ext_expires_in': '3599', 'expires_on': '1577123924', 'not_before': '1577120024', 'resource': '00000002-0000-0000-c000-000000000000', 'access_token': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSIsImtpZCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSJ9.eyJhdWQiOiIwMDAwMDAwMi0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9lN2I2YTY5MC1kMzIyLTQwODUtYjZkNi1kMGE0ZjcwZjBkN2IvIiwiaWF0IjoxNTc3MTIwMDI0LCJuYmYiOjE1NzcxMjAwMjQsImV4cCI6MTU3NzEyMzkyNCwiYWlvIjoiNDJWZ1lEQi9vVFN2VVdMend4TkhhMHVyL0RpOEFBPT0iLCJhcHBpZCI6IjMxNjBiMzBhLTczYzktNDllZS1iNGMwLWJmNTA3ZjlmZGJhNyIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2U3YjZhNjkwLWQzMjItNDA4NS1iNmQ2LWQwYTRmNzBmMGQ3Yi8iLCJvaWQiOiJjNzkzMzA4My0yNmUyLTQ1ODEtODNkYy00NjliZGY2YmM3ZjciLCJzdWIiOiJjNzkzMzA4My0yNmUyLTQ1ODEtODNkYy00NjliZGY2YmM3ZjciLCJ0ZW5hbnRfcmVnaW9uX3Njb3BlIjoiTkEiLCJ0aWQiOiJlN2I2YTY5MC1kMzIyLTQwODUtYjZkNi1kMGE0ZjcwZjBkN2IiLCJ1dGkiOiJOeGxlQ1VZNzdFS2hrRGFxOEdueEFBIiwidmVyIjoiMS4wIn0.fDtWNRpAcznVLfbTNMW7NZ-0D435g80u7y2USdcGv3qUIBaysidhekt8ech8OKFJ17hTk8hYWUra8GUmuZ8_tMIZsqLA22dHhniJXkbEdhytzyIEQaaUlc1aP1TF9nxexLyG8jugzDJsAIHHCafvr-r6VBI_qZCr1pbylnUDtzsMafuEc2pxgrgUXylfdwlZAH8YlPFJUiukZHS14olfT61R6WjU4X1rlo_uhUWOLdEYTQhPAu_ndm0OBgJ4ciAW2JnbHm7yXEitNMFdxGHMwXCdWB8T0ycXpS0ZHAoQYRvXWy4RDvYbVvsx_zNqUSUWaif1BJs4vvnfLcQlh1IdcQ'}

# print("response")
res = access_token_response.json() #.access_token

#print(access_token_response.json())


oauth_token = res["access_token"]

# build headers and data payload for upcoming http POST to CULedger.Identity for Onboarding.
headers = {'Content-Type': 'application/json',
           # 'Prefer':'respond-async', #remove comment for async
           'Authorization': 'Bearer ' + oauth_token}

onboardData = {"memberId": "testing",
                                "phoneNumber": "6138668904",
                                "emailAddress": "bubba@mailnesia.com",
                                "displayTextFromFI": "Let's get connected via MemberPass!",
                                "credentialData": {
                                    "CredentialId": "--",
                                    "CredentialDescription": "--",
                                    "Institution": "--",
                                    "CredentialName": "--",
                                    "MemberNumber": "--",
                                    "MemberSince": "--"
                                }
                             }
# print(onboardData)

onboardEndpoint ="{}member/{}/onboard".format(MEMBERPASS_URL, memberId)

print(onboardEndpoint)

onboardResponse = requests.post(onboardEndpoint, data=json.dumps(onboardData), headers=headers)

print("Onboard Response:")
print(onboardResponse)






# print 'body: ' + access_token_response.text
#
# # we can now use the access_token as much as we want to access protected resources.
# tokens = json.loads(access_token_response.text)
# access_token = tokens['access_token']
# print "access token: " + access_token
#
# api_call_headers = {'Authorization': 'Bearer ' + access_token}
# api_call_response = requests.get(test_api_url, headers=api_call_headers, verify=False)
#
# print api_call_response.text