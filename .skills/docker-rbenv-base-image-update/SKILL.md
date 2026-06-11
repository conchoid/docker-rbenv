---
name: docker-rbenv-base-image-update
description: Updates Dockerfiles in the docker-rbenv repository for a new Ruby and Debian base image release by cloning the previous version directory, updating the base Ruby image and supporting tool versions, selecting maintained preinstalled Ruby lines, checking the next available image tag sequence, and validating rbenv/ruby-build/bundler behavior. Use when asked to add or update a docker-rbenv image such as 4.0-trixie.
---

# docker-rbenv-base-image-update

Use this skill when adding or updating a `docker-rbenv` image for a new Ruby or Debian release.

## Workflow

1. Identify the source directory and target directory.
   Example: `3.3-trixie` -> `4.0-trixie`.
2. Copy the previous directory into the new target directory.
   ```bash
   cp -a <source-dir> <target-dir>
   ```
3. Update the Dockerfile to the new base image.
   ```dockerfile
   FROM ruby:<base-version>-slim-<suite>
   ```
4. Re-check the versions of:
   - `rbenv`
   - `ruby-build`
   - `bundler`
   - preinstalled Ruby lines
5. Choose preinstalled Ruby lines based on current maintenance status and repository policy. Do not keep unsupported lines by default.
6. Remove compatibility hacks only when they are no longer required for the selected Ruby lines and base image.
7. Determine the next image tag sequence by checking existing published tags.
8. Build the image locally from the target directory.
   ```bash
   docker build -t conchoid/docker-rbenv:<target-tag> <target-dir>
   ```
9. Validate compatibility:
   - confirm all `apt-get` packages still resolve
   - confirm `rbenv` works
   - confirm `ruby-build` works
   - confirm each intended Ruby version installs correctly
   - confirm `bundler` works across the bundled Ruby lines
10. If the repository has project-level or sample builds, run them with the new image and verify dependency installation, build success, runtime behavior, and Ruby version switching.

## Notes

- Ruby maintenance status, latest patch versions, `bundler`, `rbenv`, and `ruby-build` releases are all time-sensitive. Verify them from official sources at the time of the change.
- Prefer starting from the nearest existing directory for the same Debian suite.
- Read [references/release-update.md](references/release-update.md) for the repo-specific checklist, version-selection cues, and tag-sequence rule.
