FROM ruby:2.6.0-slim-stretch

ENV SETUP_HOME /opt/ruby
ENV RBENV_ROOT ${SETUP_HOME}/rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

ENV CONCHOID_DOCKER_RBENV_HOME /conchoid/docker-rbenv

# install build deps and set locale
RUN apt-get update && apt-get install -y \
      autoconf \
      bison \
      build-essential \
      curl \
      gcc \
      git \
      libffi-dev \
      libgdbm-dev \
      libgdbm3 \
      libncurses5-dev \
      libreadline6-dev \
      libssl1.0-dev \
      libyaml-dev \
      make \
      zlib1g-dev \
      locales \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install rbenv
RUN RBENV_VERSION="v1.1.1" \
  && git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
  && cd "${RBENV_ROOT}" \
  && git checkout "${RBENV_VERSION}" \
  && src/configure && make -C src \
  && rm -rf .git

# install ruby-build
RUN RUBY_BUILD_DIR="${RBENV_ROOT}/plugins/ruby-build" \
  && RUBY_BUILD_VERSION="v20181225" \
  && mkdir -p "${RBENV_ROOT}/plugins" \
  && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
  && cd "${RUBY_BUILD_DIR}" \
  && git checkout "${RUBY_BUILD_VERSION}" \
  && rm -rf .git

# install runtimes and bundler
# Newer version of Bundler2.x is also available but it does not support ruby2.2 and lower version anymore.
RUN BUNDLER_VERSION="1.17.0" \
  && unset GEM_HOME \
  && for version in "2.2.10" "2.3.8" "2.4.5" "2.5.3" "2.6.0"; do \
    rbenv install "${version}" \
    && rbenv global "${version}" \
    && gem install bundler -v ${BUNDLER_VERSION} \
  ; done \
  && rbenv global system
