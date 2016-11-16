FROM gitlab/gitlab-ce:latest
MAINTAINER Computer Science House

# Install the OpenID Connect strategy for OmniAuth
RUN cd /opt/gitlab/embedded/service/gitlab-rails && \
    printf "\n# OpenID Connect OmniAuth strategy\ngem 'omniauth-openid-connect'" >> Gemfile && \
    /opt/gitlab/embedded/bin/bundle install --without development test --path=/opt/gitlab/embedded/service/gem

# Patch the GitLab OmniAuth callback controller to support multiple OIDC providers
ADD patches/omniauth_callbacks_controller.patch /tmp/
RUN patch /opt/gitlab/embedded/service/gitlab-rails/app/controllers/omniauth_callbacks_controller.rb /tmp/omniauth_callbacks_controller.patch && \
    rm -rf /tmp/omniauth_callbacks_controller.patch

# Patch the OAuth User model to support linking by UUID
ADD patches/user.rb.patch /tmp/
RUN patch /opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/o_auth/user.rb /tmp/user.rb.patch && \
    rm -rf /tmp/user.rb.patch

# Patch the LDAP Person model to support linking by UUID
ADD patches/person.rb.patch /tmp/
RUN patch /opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/ldap/person.rb /tmp/person.rb.patch && \
    rm -rf /tmp/person.rb.patch
