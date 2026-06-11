---
name: docker-rbenv-os-update
description: Updates an existing docker-rbenv image line to a new Debian base release by switching the Ruby base image to an available tag on the new suite, preserving required apt packages and legacy compatibility setup, and validating rbenv/ruby-build/bundler behavior across the bundled Ruby versions. Use when asked to migrate an existing docker-rbenv line such as 3.3-bookworm to trixie.
---

# docker-rbenv-os-update

Use this skill when migrating an existing `docker-rbenv` line from one Debian suite to another without redefining the overall image family.

## Workflow

1. Identify the source Dockerfile and target directory.
   Example: `3.3-bookworm/Dockerfile` -> `3.3-trixie/Dockerfile`.
2. If the target directory does not exist, create it and copy the source Dockerfile into it.
3. Update the base image from `ruby:<old-base>-slim-<old-suite>` to an available `ruby:<new-base>-slim-<new-suite>` tag.
4. If the exact patch tag for the new Debian suite does not exist, choose the nearest available maintained patch tag for that Ruby line and document the reason.
5. Keep the installed `apt-get` packages unless a compatibility issue is confirmed. Do not silently remove required libraries.
6. Re-check compatibility shims and legacy packages needed by the bundled Ruby versions.
   - Verify whether `libssl1.0-dev` or equivalent compatibility setup is still required.
   - Verify whether the package source or repository configuration still works on the new suite.
7. Build the image locally from the repository root.
   ```bash
   cd docker-rbenv
   docker build -t conchoid/docker-rbenv:<target-tag> -f <target-dir>/Dockerfile .
   ```
8. Validate compatibility:
   - confirm all `apt-get` packages still resolve
   - confirm `rbenv` works
   - confirm `ruby-build` works
   - confirm each intended Ruby version installs correctly
   - confirm `bundler` is available
   - confirm locale settings still work
   - confirm any legacy OpenSSL or compatibility package setup still functions
9. If the repository has project-level or sample builds, run them with the new image and verify dependency installation, build success, runtime behavior, and Ruby version switching.

## Notes

- Official Ruby Docker tags differ by suite and patch availability. Always confirm the target tag exists before pinning it.
- Existing bundled Ruby versions may force legacy compatibility packages. Re-check those assumptions each time you change the Debian suite.
- Read [references/os-update.md](references/os-update.md) for the repo-specific checklist and the original `3.3-bookworm -> 3.3-trixie` example.
