##OAuth 2.0

CULedger provides sample scripts to help you connect with the OAuth 2.0 endpoints.  Edit the `config.sh` file and enter the information contained in the CULedger Welcome email.  You should have received the following details.

	CLIENTID=""            
	SECRET=""              
	TENANTID=""            
	SUBSCRIPTIONKEY=""     
	ENDPOINT="" 				

Enter that information into the `config.sh` file and you should be able to connect to the OAuth endpoints to Onboard and Authenticate your members.

The only additional requirement is that the `jq` library be installed.  You can find installation procedures here: [https://stedolan.github.io/jq/](https://stedolan.github.io/jq/)

###Onboard
The `onboard.sh` script expects to receieve the members ID (-i) and phone number (-p) parameters.  Simply execute the script without any parameters for additional information.

###Authenticate
The `authenticate.sh` script expects to receieve the members ID (-i).  Simply execute the script without any parameters for additional information.


