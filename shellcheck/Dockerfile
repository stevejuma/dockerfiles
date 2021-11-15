# Shellcheck
#
# docker run \
#   --rm -it \
#	stevejuma/shellcheck
#

FROM alpine:latest AS alpine
LABEL maintainer "Steve Juma <stevejuma@ju.ma>"
ENV SHELLCHECK_VERSION v0.8.0

# Put the right binary for each architecture into place for the
# multi-architecture docker image.
RUN set -x; \
  arch="$(uname -m)"; \
  echo "arch is $arch"; \
  if [ "${arch}" = 'armv7l' ]; then \
    arch='armv6hf'; \
  fi; \
  url_base='https://github.com/koalaman/shellcheck/releases/download/'; \
  tar_file="${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.${arch}.tar.xz"; \
  wget "${url_base}${tar_file}" -O - | tar xJf -; \
  mv "shellcheck-${SHELLCHECK_VERSION}/shellcheck" /bin/; \
  rm -rf "shellcheck-${SHELLCHECK_VERSION}"; \
  ls -laF /bin/shellcheck

FROM alpine:latest
COPY --from=alpine /bin/shellcheck /bin/
RUN apk add --no-cache --upgrade grep
RUN apk add --no-cache file bash
CMD ["shellcheck"]