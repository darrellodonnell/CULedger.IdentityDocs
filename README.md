## Welcome to CULedger IdentityDocs Code Samples

### Intro Video

Watch the Connect.Me introduction video [Introduction to Connect.me](https://culedger.s3.amazonaws.com/videos/InstallingConnectMeforCULedger-PoCs.mp4)

### OAuth Protected

Your MemberPass API endpoint is protected by Azure AD using OAuth2. All interactions with the API require an OAuth token. The OAuth endpoint can be found at:

`https://login.microsoftonline.com/{tenantId}/oauth2/token`

NOTE: You will need the *tenantId* value that is shared with you along with your OAuth credentials and your endpoint URL. 

The code examples in the ./oauth folder all get a token, then make the API call. 

### Explore the samples

Sample code is included for shell scripting and Nodejs. See the [Github repo](https://github.com/darrellodonnell/CULedger.IdentityDocs) for the examples. 

* onboard.sh - shell script that provides a sample onboarding
* authenticate.sh - shell script that authenticates a sample member

### API Documentation

Swagger docs can be found [here](https://app.swaggerhub.com/apis-docs/CULedger/CULedger.Identity/0.2.0/)

A Postman collection is included in the repo.

### Customize the Samples

Simply change the `endpoint` definition in the shell script files to the URL provided by CULedger to see the customized messages in Connect.me
