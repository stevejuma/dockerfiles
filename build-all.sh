#!/usr/bin/env bash
set -e
set -o pipefail

SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
REPO_URL="${REPO_URL:-stevejuma}"
JOBS=${JOBS:-2}

ERRORS="$(pwd)/errors"

build_and_push(){
	base=$1
	suite=$2
	build_dir=$3

    echo "Building ${REPO_URL}/${base}:${suite} for context ${build_dir}"
    docker buildx build --rm  --force-rm --platform linux/amd64,linux/arm64,linux/arm/v7 -t "${REPO_URL}/${base}:${suite}" "${build_dir}" || return 1

	# on successful build, push the image
	echo "                       ---                                   "
	echo "Successfully built ${base}:${suite} with context ${build_dir}"
	echo "                       ---                                   "

    # try push a few times because notary server sometimes returns 401 for
	# absolutely no reason
	n=0
	until [ $n -ge 5 ]; do
		docker buildx build --rm  --force-rm --platform linux/amd64,linux/arm64,linux/arm/v7 --push -t "${REPO_URL}/${base}:${suite}" "${build_dir}" && break
		echo "Try #$n failed... sleeping for 15 seconds"
		n=$((n+1))
		sleep 15
	done
}

dofile() {
	f=$1
	image=${f%Dockerfile}
	base=${image%%\/*}
	build_dir=$(dirname "$f")
	suite=${build_dir##*\/}

	if [[ -z "$suite" ]] || [[ "$suite" == "$base" ]]; then
		suite=latest
	fi

	{
		$SCRIPT build_and_push "${base}" "${suite}" "${build_dir}"
	} || {
	# add to errors
	echo "${base}:${suite}" >> "$ERRORS"
}
echo
echo
}

main(){
	# get the dockerfiles
	IFS=$'\n'
	mapfile -t files < <(find -L . -iname '*Dockerfile' | sed 's|./||' | sort)
	unset IFS

	# build all dockerfiles
	echo "Running in parallel with ${JOBS} jobs."
	parallel --tag --verbose --ungroup -j"${JOBS}" "$SCRIPT" dofile "{1}" ::: "${files[@]}"

	if [[ ! -f "$ERRORS" ]]; then
		echo "No errors, hooray!"
	else
		echo "[ERROR] Some images did not build correctly, see below." >&2
		echo "These images failed: $(cat "$ERRORS")" >&2
		exit 1
	fi
}

run(){
	args=$*
	f=$1

	if [[ "$f" == "" ]]; then
		rm -rf ./errors
		main "$args"
	else
		$args
	fi
}

run "$@"