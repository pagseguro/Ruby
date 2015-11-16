require_relative "../boot"

# Authorization
#
#   You need to give:
#     - notification_url
#     - redirect_url
#     - permissions defaults to all permissions
#     - applications credentials (APP_ID, APP_KEY)
#
#   You can pass this parameters to PagSeguro::AuthorizationRequest#new
#
# PS: For more details look the class PagSeguro::AuthorizationRequest

credentials = PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')

options = {
  credentials: credentials, # Unnecessary if you set in application config
  permissions: [:searches, :notifications],
  notification_url: 'http://example.com/',
  redirect_url: 'http://example.com/'
}

authorization_request = PagSeguro::AuthorizationRequest.new(options)

if authorization_request.create
  print "Use this link to confirm authorizations: "
  puts authorization_request.url
else
  puts authorization_request.errors.join("\n")
end
