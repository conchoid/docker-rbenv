FROM ruby:2.7.5-slim-buster

ENV ROCRO_SETUP_HOME /opt/ruby
ENV RBENV_ROOT ${ROCRO_SETUP_HOME}/rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

# install build deps and set locale
RUN apt-get update --allow-releaseinfo-change && apt-get install -y \
      autoconf \
      bison \
      bzip2 \
      build-essential \
      curl \
      gcc \
      git \
      gnupg \
      libssl-dev \
      libgdbm-dev \
      libgdbm-compat-dev \
      libncurses5-dev \
      libreadline6-dev \
      locales \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main" > /etc/apt/sources.list.d/bionic-security.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 \
    && apt-get update && apt-cache policy libssl1.0-dev && apt-get install -y libssl1.0-dev \
    && rm -f /etc/apt/sources.list.d/bionic-security.list

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV RUBYOPT -EUTF-8

# install rbenv
RUN RBENV_VERSION="v1.2.0" \
  && git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
  && cd "${RBENV_ROOT}" \
  && git checkout "${RBENV_VERSION}" \
  && src/configure && make -C src \
  && rm -rf .git

# install ruby-build
RUN RUBY_BUILD_VERSION="v20211203" \
  && RUBY_BUILD_DIR="${RBENV_ROOT}/plugins/ruby-build" \
  && mkdir -p "${RBENV_ROOT}/plugins" \
  && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
  && cd "${RUBY_BUILD_DIR}" \
  && git checkout "${RUBY_BUILD_VERSION}" \
  && ./install.sh \
  && rm -rf .git

# install runtimes and bundler
# Newer version of Bundler2.x is also available but it does not support ruby2.2 and lower version anymore.
RUN BUNDLER_VERSION="1.17.3" \
  && BUNDLER2_VERSION="2.2.33" \
  && unset GEM_HOME \
  && for version in "2.5.9" "2.6.9" "2.7.5" "3.0.3"; do \
    rbenv install "${version}" \
    && rbenv global "${version}" \
    && gem install bundler -v ${BUNDLER_VERSION} \
    && if [ "${version}" = "2.5.9" ] || [ "${version}" = "2.6.9" ] || [ "${version}" = "2.7.5" ] || [ "${version}" = "3.0.3" ] ; then \
    gem install bundler -v ${BUNDLER2_VERSION} ; fi \
    && rm -rf ${RBENV_ROOT}/versions/${version}/share \
    && ls -1d ${RBENV_ROOT}/versions/${version}/lib/ruby/gems/2.*/doc | xargs rm -rf \
  ; done \
  && rbenv global system \
  # System version(ruby2.6.6) comes with bundler 1.17.2 pre-installed, but not 2.x.
  && gem install bundler -v ${BUNDLER2_VERSION}
