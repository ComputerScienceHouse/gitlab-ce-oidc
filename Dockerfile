FROM gitlab/gitlab-ce:latest
MAINTAINER Computer Science House

# Install the OpenID Connect strategy for OmniAuth
RUN cd /opt/gitlab/embedded/service/gitlab-rails && \
printf "\n# OpenID Connect OmniAuth strategy\ngem 'omniauth-openid-connect'" >> Gemfile && \
/opt/gitlab/embedded/bin/bundle install --without development test --path=/opt/gitlab/embedded/service/gem

# Patch the GitLab OmniAuth callback controller
ADD omniauth_callbacks_controller.patch /tmp/
RUN patch /opt/gitlab/embedded/service/gitlab-rails/app/controllers/omniauth_callbacks_controller.rb /tmp/omniauth_callbacks_controller.patch && \
rm -rf /tmp/omniauth_callbacks_controller.patch

