# Existing Ruby line OS update reference

Repository: `docker-rbenv`

## Standard pattern

- Update an existing Ruby line from one Debian suite to another
- Change the base image to an available `ruby:<patch>-slim-<suite>` tag on the new suite
- Preserve required `apt-get` packages and any compatibility package setup
- Build from the repository root with the target Dockerfile

## Example from the original procedure

- Source Dockerfile: `3.3-bookworm/Dockerfile`
- Target Dockerfile: `3.3-trixie/Dockerfile`
- Base image change:
  - from `ruby:3.3.5-slim-bookworm`
  - to `ruby:3.3.10-slim-trixie`
- Example image tag: `conchoid/docker-rbenv:v1.3.2-1-3.3.10-trixie`

```bash
cd docker-rbenv
docker build -t conchoid/docker-rbenv:v1.3.2-1-3.3.10-trixie -f 3.3-trixie/Dockerfile .
```

## Checklist

- Confirm the target Ruby Docker tag exists for the new Debian suite.
- Preserve required `apt-get` libraries unless incompatibility is confirmed.
- Verify `rbenv` still works.
- Verify `ruby-build` still works.
- Verify each intended Ruby version installs correctly.
- Verify `bundler` is available.
- Verify locale-related behavior.
- Verify whether `libssl1.0-dev` or equivalent compatibility setup is still required and still obtainable.
- Verify a real Ruby project can install dependencies, build, and run.

## Cautions

- Debian release changes can affect package names and versions.
- The exact Ruby patch used for the new suite may differ from the old suite because official image tags are not always mirrored exactly.
- Legacy compatibility packages sourced from older repositories are fragile and should be revalidated on every OS update.
