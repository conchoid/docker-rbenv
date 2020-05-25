FROM ruby:2.6.5-slim-stretch

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
RUN RBENV_VERSION="v1.1.2" \
  && git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
  && cd "${RBENV_ROOT}" \
  && git checkout "${RBENV_VERSION}" \
  && src/configure && make -C src \
  && rm -rf .git

# install ruby-build
RUN RUBY_BUILD_VERSION="v20191225" \
  && RUBY_BUILD_DIR="${RBENV_ROOT}/plugins/ruby-build" \
  && mkdir -p "${RBENV_ROOT}/plugins" \
  && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
  && cd "${RUBY_BUILD_DIR}" \
  && git checkout "${RUBY_BUILD_VERSION}" \
  && rm -rf .git

# install runtimes and bundler
# Newer version of Bundler2.x is also available but it does not support ruby2.2 and lower version anymore.
RUN BUNDLER_VERSION="1.17.3" \
  && BUNDLER2_VERSION="2.1.4" \
  && unset GEM_HOME \
  && for version in "2.3.8" "2.4.9" "2.5.7" "2.6.5" "2.7.0"; do \
    rbenv install "${version}" \
    && rbenv global "${version}" \
    && gem install bundler -v ${BUNDLER_VERSION} \
    && if [ "${version}" = "2.3.8" ] || [ "${version}" = "2.4.9" ] || [ "${version}" = "2.5.7" ] || [ "${version}" = "2.6.5" ] ; then \
    gem install bundler -v ${BUNDLER2_VERSION} ; fi \
  ; done \
  && rbenv global system \
  # System version(ruby2.6.5) comes with bundler 1.17.2 pre-installed, but not 2.x.
  && gem install bundler -v ${BUNDLER2_VERSION}
