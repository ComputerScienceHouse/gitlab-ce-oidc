FROM gitlab/gitlab-ce:latest
MAINTAINER Computer Science House

# Install the OpenID Connect strategy for OmniAuth
RUN cd /opt/gitlab/embedded/service/gitlab-rails && \
printf "\n# OpenID Connect OmniAuth strategy\ngem 'omniauth-openid-connect'" >> Gemfile && \
/opt/gitlab/embedded/bin/bundle install --without development test --path=/opt/gitlab/embedded/service/gem && \
sed -i 's/:cas3/:cas3, :openid_connect/' /opt/gitlab/embedded/service/gitlab-rails/app/controllers/omniauth_callbacks_controller.rb

