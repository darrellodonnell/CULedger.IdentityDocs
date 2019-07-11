# C# Example

The following example conducts a /heartbeat call after acquiring an access token via OAuth2.

```C#

/*
.nuget\packages\newtonsoft.json\12.0.2
*/
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Linq;
using System.Text;
using System.Web;
using Newtonsoft.Json; //NOTE: Newtonsoft.JSON is required (nuget package)

namespace CULedger.IdentityOAuthSample
{
    class Program
    {
        
        static string heartbeat = null;

        static string clientId = "<CLIENTID>";                  // UUID for Client 
        static string clientSecret = "<CLIENTSECRET>";          // private key for Client
        static string tenantId = "<TENANTID>";                  // UUID for TenantID (CULedger AD)
        static string endpointURL = "<ENDPOINTURL>";            // e.g. https://sample.culedgerapi.com/CULedger/CULedger.Identity/0.2.0
        static string subscriptionKey = "<SUBSCRIPTIONKEY>";    // SUBSCRIPTION KEY 



        static void Main(string[] args)
        {
            Console.WriteLine("getting token...");
            // trigger off async GetTokenAndHeartbeat
            GetTokenAndHeartbeat().Wait();

        }
        /*
         * GetToken - access the Azure Active Directory OAuth2 endpoint and get an access token.
         *
         * This token is required for access to the deeper Heartbeat call.
         */
        private static async Task<int> GetTokenAndHeartbeat()
        {
            

            using (var client = new HttpClient())
            {
                //Define Headers
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                string credentials = String.Format("{0}:{1}", clientId, clientSecret);

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.UTF8.GetBytes(credentials)));

                //Prepare Request Body
                List<KeyValuePair<string, string>> requestData = new List<KeyValuePair<string, string>>();
                requestData.Add(new KeyValuePair<string, string>("grant_type", "client_credentials"));

                FormUrlEncodedContent requestBody = new FormUrlEncodedContent(requestData);

                //Request Token
                var request = await client.PostAsync("https://login.microsoftonline.com/" + tenantId + "/oauth2/token", requestBody);
                var response = await request.Content.ReadAsStringAsync();
                AccessToken accessToken = JsonConvert.DeserializeObject<AccessToken>(response);
                Console.WriteLine(String.Format("Access Token: {0}", accessToken.access_token));
                string hb = await GetHeartbeat(accessToken.access_token);


                return 0;
            }
        }
        /**
         * GetHeartbeat - using the OAuth token (accessToken) ping the /heartbeat API call to get the status of the system.
         *
         * This is a non-destructive test (i.e. doesn't query or create/update member data) used as a simple example.
         * 
         * **/
        private static async Task<string> GetHeartbeat(string accessToken)
        {
            string token = accessToken;

            
            string hbString = "";
            string baseURL = endpointURL + "/heartbeat";
            
            using (var client = new HttpClient())
            {
                // headers
                client.BaseAddress = new Uri(baseURL);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " +  token);
                client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", subscriptionKey);

                HttpResponseMessage response = await client.GetAsync(baseURL);
                
                hbString = await response.Content.ReadAsStringAsync();
                Console.WriteLine("Using token: " + token);
                Console.WriteLine("URL: " + baseURL);
                Console.WriteLine("status: " + response.StatusCode.ToString());
                Console.WriteLine("Heartbeat: " + hbString);
                
                return hbString;


            }

        }
        public class AccessToken
        {
            public string access_token { get; set; }
            public string token_type { get; set; }
            public long expires_in { get; set; }
        }
    }
    

   
}


```
