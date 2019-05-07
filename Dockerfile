FROM gitlab/gitlab-ce:11.10.4-ce.0
MAINTAINER Computer Science House <rtp@csh.rit.edu>

# Install the OpenID Connect strategy for OmniAuth
RUN cd /opt/gitlab/embedded/service/gitlab-rails \
    && printf "\n# OpenID Connect OmniAuth strategy\ngem 'omniauth-openid-connect'" >> Gemfile \
    && /opt/gitlab/embedded/bin/bundle install --without development test

