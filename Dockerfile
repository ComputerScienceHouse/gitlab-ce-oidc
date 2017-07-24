FROM gitlab/gitlab-ce:latest
MAINTAINER Computer Science House

# Install the OpenID Connect strategy for OmniAuth
RUN cd /opt/gitlab/embedded/service/gitlab-rails \
    && printf "\n# OpenID Connect OmniAuth strategy\ngem 'omniauth-openid-connect'" >> Gemfile \
    && /opt/gitlab/embedded/bin/bundle install --without development test

# Add patches to the container
ADD patches/*.patch /tmp/

# Apply patches
RUN apt-get -y update \
    && apt-get -y install patch \
    && patch /opt/gitlab/embedded/service/gitlab-rails/app/controllers/omniauth_callbacks_controller.rb /tmp/omniauth_callbacks_controller.patch \
    && patch /opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/o_auth/user.rb /tmp/user.rb.patch \
    && patch /opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/ldap/person.rb /tmp/person.rb.patch \
    && apt-get -y remove patch \
    && apt-get -y clean \
    && rm -f /tmp/*.patch

