var request = require('request');
var path = require('path');
var config = require(path.resolve('./config/config'));

/*

myCuidHandler.sendInvitation(user._id, user.phone,
    (error, response, body, attempt) => {
      // do something here when sendInvitation has been completed
      // store results so that you know the connection has been established
      }
    )

  myCuidHandler.authenticate(user._id,
    (error, response, body, attempt) => {
      // do something here when sendInvitation has been completed
      // store results so that you know the connection has been established
      //if(body && body.memberId){
      //  success
      //} else {
      //  failure
      }
    )

*/


function sendInvitation (member_id, phone_number, callback) {
  sendRequest(buildRequest(member_id, 'onboard', {
    "memberId": member_id,
    "phoneNumber": phone_number,
    "emailAddress": "",
    "displayTextFromFI": "Let's get connected via MyCUID!",
    "credentialData": {
        "CredentialId": "UUID-GOES-HERE",
        "Institution": "CULedger Credit Union",
        "Credential": null,
        "memberNumber": member_id,
        "memberSince": null
      }
    }, 'POST'), 
    callback)
}

function authenticate(member_id, callback) {
  sendRequest(buildRequest(member_id, 'authenticate', {}, 'PUT'), callback)
}

function sendRequest (options, successCallback) {
  request(options, (error, response, body) => {
    if (!error && response.statusCode == 200) {
      successCallback(error, response, body, "success")
    } else {
      console.log(body)
      console.log("something went wrong", response.statusCode)
    }
  })
}

function buildRequest(member_id, uri, json_data, request_method) {
  /*
   * To run this against a local docker image replace the baseUrl in the return
   * statement with this one: 
   *    baseUrl: "http://localhost:8080/CULedger/CULedger.Identity/0.2.0/member/".concat(member_id),
   *    baseUrl: "https://culidentity.culedgerapi.com/CULedger/CULedger.Identity/0.2.0/member/".concat(member_id),
   */
  return {
    method: request_method,
    baseUrl: config.app.identityApiBaseUrl.concat(member_id),
    uri: uri,
    headers: {"Content-Type": "application/json"},
    json: json_data
  }
}

module.exports.sendInvitation = sendInvitation
module.exports.authenticate = authenticate
