FROM gitlab/gitlab-ce:latest
MAINTAINER Computer Science House

# Install the OpenID Connect strategy for OmniAuth
RUN gem install omniauth-openid-connect

