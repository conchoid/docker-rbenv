FROM ruby:4.0.2-slim-trixie

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
      libffi-dev \
      libgdbm-dev \
      libgdbm-compat-dev \
      libncurses5-dev \
      libreadline6-dev \
      libssl-dev \
      libyaml-dev \
      locales \
      zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV RUBYOPT -EUTF-8

# install rbenv
RUN RBENV_VERSION="v1.3.2" \
  && git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
  && cd "${RBENV_ROOT}" \
  && git checkout "${RBENV_VERSION}" \
  && src/configure && make -C src \
  && rm -rf .git

# install ruby-build
RUN RUBY_BUILD_VERSION="v20260327" \
  && RUBY_BUILD_DIR="${RBENV_ROOT}/plugins/ruby-build" \
  && mkdir -p "${RBENV_ROOT}/plugins" \
  && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
  && cd "${RUBY_BUILD_DIR}" \
  && git checkout "${RUBY_BUILD_VERSION}" \
  && ./install.sh \
  && rm -rf .git

# install runtimes and bundler
RUN BUNDLER_VERSION="4.0.9" \
  && unset GEM_HOME \
  && gem install bundler -v ${BUNDLER_VERSION} \
  && for version in "3.2.11" "3.3.11" "3.4.9"; do \
    rbenv install "${version}" \
    && rbenv global "${version}" \
    && gem install bundler -v ${BUNDLER_VERSION} \
    && rm -rf ${RBENV_ROOT}/versions/${version}/share \
    && ls -1d ${RBENV_ROOT}/versions/${version}/lib/ruby/gems/3.*/doc | xargs rm -rf \
  ; done \
  && rbenv global system
