# Docker Hub: conchoid/docker-rbenv:v1.3.2-1-4.0.5-trixie
FROM ruby:4.0.5-slim-trixie

ENV ROCRO_SETUP_HOME=/opt/ruby
ENV RBENV_ROOT=${ROCRO_SETUP_HOME}/rbenv
ENV PATH=${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

# install build deps and set locale
RUN apt-get update --allow-releaseinfo-change && apt-get upgrade -y && apt-get install -y --no-install-recommends \
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

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV RUBYOPT=-EUTF-8

# install rbenv
RUN RBENV_VERSION="v1.3.2" \
  && git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
  && cd "${RBENV_ROOT}" \
  && git checkout "${RBENV_VERSION}" \
  && src/configure && make -C src \
  && rm -rf .git

# install ruby-build
RUN RUBY_BUILD_VERSION="v20260616" \
  && RUBY_BUILD_DIR="${RBENV_ROOT}/plugins/ruby-build" \
  && mkdir -p "${RBENV_ROOT}/plugins" \
  && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
  && cd "${RUBY_BUILD_DIR}" \
  && git checkout "${RUBY_BUILD_VERSION}" \
  && ./install.sh \
  && rm -rf .git

# install runtimes and patched default gems
RUN BUNDLER_VERSION="4.0.9" \
  && JSON_VERSION="2.19.2" \
  && NET_IMAP_VERSION="0.6.4" \
  && unset GEM_HOME GEM_PATH BUNDLE_APP_CONFIG BUNDLE_PATH BUNDLE_BIN \
  && rbenv global system \
  && install_runtime_gems() { \
    local_gem="gem" \
    && local_ruby="ruby" \
    && if [ -e "${RBENV_ROOT}/shims/gem" ]; then \
      local_gem="${RBENV_ROOT}/shims/gem" \
      && local_ruby="${RBENV_ROOT}/shims/ruby"; \
    fi \
    && "${local_gem}" install bundler -v "${BUNDLER_VERSION}" --no-document \
    && "${local_gem}" install json -v "${JSON_VERSION}" --no-document \
    && "${local_gem}" install net-imap -v "${NET_IMAP_VERSION}" --no-document \
    && GEM_DEFAULT_DIR="$("${local_ruby}" -e 'print Gem.default_dir')" \
    && RUBY_LIBDIR="$("${local_ruby}" -e 'print RbConfig::CONFIG["rubylibdir"]')" \
    && RUBY_ARCHDIR="$("${local_ruby}" -e 'print RbConfig::CONFIG["rubyarchdir"]')" \
    && JSON_GEM_DIR="${GEM_DEFAULT_DIR}/gems/json-${JSON_VERSION}" \
    && JSON_EXT_DIR="$("${local_ruby}" -e 'print Gem::Specification.find_by_name("json", "= 2.19.2").extension_dir')" \
    && cp "${JSON_GEM_DIR}/lib/json.rb" "${RUBY_LIBDIR}/json.rb" \
    && rm -rf "${RUBY_LIBDIR}/json" \
    && cp -a "${JSON_GEM_DIR}/lib/json" "${RUBY_LIBDIR}/json" \
    && mkdir -p "${RUBY_ARCHDIR}/json/ext" \
    && cp "${JSON_EXT_DIR}/json/ext/parser.so" "${RUBY_ARCHDIR}/json/ext/parser.so" \
    && cp "${JSON_EXT_DIR}/json/ext/generator.so" "${RUBY_ARCHDIR}/json/ext/generator.so" \
    && rm -f "${GEM_DEFAULT_DIR}/specifications/default"/json-*.gemspec \
    && find "${GEM_DEFAULT_DIR}/specifications" -maxdepth 1 -type f -name 'json-*.gemspec' ! -name "json-${JSON_VERSION}.gemspec" -delete \
    && find "${GEM_DEFAULT_DIR}/specifications" -maxdepth 1 -type f -name 'net-imap-*.gemspec' ! -name "net-imap-${NET_IMAP_VERSION}.gemspec" -delete \
    && find "${GEM_DEFAULT_DIR}/gems" -maxdepth 1 -type d -name 'json-*' ! -name "json-${JSON_VERSION}" -exec rm -rf {} + \
    && find "${GEM_DEFAULT_DIR}/gems" -maxdepth 1 -type d -name 'net-imap-*' ! -name "net-imap-${NET_IMAP_VERSION}" -exec rm -rf {} +; \
  } \
  && install_runtime_gems \
  # NOTE: rbenv install does not include the system version 4.0.5.
  # System version 4.0.5 uses a symbolic link in /usr/local/.
  && for version in "3.2.11" "3.3.11" "3.4.9" "4.0.5"; do \
    if [ "${version}" = "4.0.5" ] ; then \
      ln -sf "/usr/local/" "${RBENV_ROOT}/versions/${version}" \
      && export RBENV_VERSION="${version}" \
      && install_runtime_gems \
      && unset RBENV_VERSION; \
    else \
      rbenv install "${version}" \
      && rbenv global "${version}" \
      && export RBENV_VERSION="${version}" \
      && install_runtime_gems \
      && unset RBENV_VERSION \
      && rm -rf ${RBENV_ROOT}/versions/${version}/share \
      && ls -1d ${RBENV_ROOT}/versions/${version}/lib/ruby/gems/*/doc | xargs rm -rf; \
    fi \
  ; done \
  && rbenv global system
