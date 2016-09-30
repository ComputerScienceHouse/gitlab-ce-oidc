FROM gitlab/gitlab-ce:latest
MAINTAINER Computer Science House

# Install the OpenID Connect strategy for OmniAuth
RUN gem install omniauth-openid-connect

# Add the callback handler
RUN echo 'def openidconnect\n\
  handle_omniauth\n\
end\n'\
>> /opt/gitlab/embedded/service/gitlab-rails/app/controllers/omniauth_callbacks_controller.rb

# Add the configuration block to the Devise initializer
RUN echo 'config.omniauth :openid_connect, {\n\
  name: :openid_connect,\n\
  scope: [:openid, :profile],\n\
  response_type: :code,\n\
  client_options: {\n\
    port: 443,\n\
    scheme: "https",\n\
    host: ENV["GITLAB_OIDC_ISSUER_URL"],\n\
    identifier: ENV["GITLAB_OIDC_CLIENT_ID"],\n\
    secret: ENV["GITLAB_OIDC_SECRET"],\n\
    redirect_uri: ENV["GITLAB_OIDC_BASE_URL"] + "/users/auth/openid_connect/callback",\n\
  },\n\
}\n'\
>> /opt/gitlab/embedded/service/gitlab-rails/config/initializers/devise.rb

