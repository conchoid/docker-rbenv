FROM ruby:2.3.6-alpine3.4

ENV SETUP_HOME /opt/ruby
ENV RBENV_ROOT ${SETUP_HOME}/rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

RUN apk add --no-cache --update \
# rbenv build dependence
    bash=4.3.42-r5 \
    git=2.8.6-r0 \
    make=4.1-r1 \
    gcc=5.3.0-r0 \
    libc-dev=0.7-r0 \
# ruby build dependence 
    autoconf=2.69-r0 \
    curl=7.58.0-r0 \
    bison=3.0.4-r0 \
    coreutils=8.25-r0 \
    readline-dev=6.3.008-r4 \
    linux-headers=4.4.6-r1 \
    patch=2.7.5-r1 \
    libffi-dev=3.2.1-r2 \
    gdbm=1.11-r1 \
    openssl-dev=1.0.2n-r0

# install rbenv
RUN set -x \
    && RBENV_VERSION="v1.1.1" \
    && git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
    && cd "${RBENV_ROOT}" \
    && git checkout "${RBENV_VERSION}" \
    && src/configure && make -C src \
    && rm -rf .git

# install ruby-build as rbenv plugin
RUN set -x \
    && RUBY_BUILD_DIR="${RBENV_ROOT}/plugins/ruby-build" \
    && RUBY_BUILD_VERSION="v20171215" \
    && mkdir -p "${RBENV_ROOT}/plugins" \
    && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
    && cd "${RUBY_BUILD_DIR}" \
    && git checkout "${RUBY_BUILD_VERSION}" \
    && rm -rf .git

