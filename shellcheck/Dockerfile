# Shellcheck
#
# docker run \
#   --rm -it \
#	stevejuma/shellcheck
#
FROM debian:bullseye-slim
LABEL maintainer "Steve Juma <stevejuma@ju.ma>"

RUN apt-get update && apt-get install -y \
	file \
	shellcheck \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

CMD ["shellcheck"]