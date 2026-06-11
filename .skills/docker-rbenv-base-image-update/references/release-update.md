# Ruby image update reference

Repository: `docker-rbenv`

## Standard pattern

- Copy the previous directory for the same Debian suite into a new target directory
- Change the base image to `ruby:<base-version>-slim-<suite>`
- Re-check `rbenv`, `ruby-build`, `bundler`, and the preinstalled Ruby lines
- Build from the target directory

## Example from the original procedure

- Source directory: `3.3-trixie`
- Target directory: `4.0-trixie`
- Example base image: `ruby:4.0.2-slim-trixie`

```bash
cp -a /home/oik/go/src/github.com/conchoid/docker-rbenv/3.3-trixie \
  /home/oik/go/src/github.com/conchoid/docker-rbenv/4.0-trixie

docker build -t conchoid/docker-rbenv:v1.3.2-1-4.0.2-trixie \
  /home/oik/go/src/github.com/conchoid/docker-rbenv/4.0-trixie
```

## Checklist

- Update the base Ruby image to the new version and suite.
- Verify current maintenance status for Ruby branches.
- Select maintained preinstalled Ruby lines and their latest patch releases.
- Verify the latest compatible `bundler` version.
- Verify the latest `ruby-build` release.
- Verify the latest `rbenv` release.
- Remove old compatibility workarounds only when they are no longer needed.
- Check published image tags and choose the next available sequence number.
- Verify `rbenv`, `ruby-build`, and `bundler` all work after the update.

## Cautions

- Ruby branch maintenance status changes over time, so preinstalled-version decisions must be rechecked for every update.
- `bundler` compatibility depends on the minimum Ruby version you still support in the image.
- Existing image tags affect the sequence number; do not assume `-1` is available.
