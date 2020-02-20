#!/usr/bin/env bash

# Load the user definitions
. definitions.sh

# Call the validation script
. validate.sh

# Check if the TRAVIS_TAG variable is defined.
if [ -z ${TRAVIS_TAG+x} ]; then
    echo "ERROR: TRAVIS_TAG environmental variable not defined!"
    exit 1
fi

# Other definitions, not defined by the user
docker_org_name=tidair
docker_repo=pysmurf-server
this_repo=https://github.com/slaclab/pysmurf-stable-docker

# Get mcs file
if [ -z ${mcs_use_local+x} ]; then
    echo "Getting mcs file from ${mcs_repo}"

    # Get the mcs file assent
    wget -O local_files/${mcs_file_name} ${mcs_repo}/releases/${mcs_repo_tag}/download/${mcs_file_name} || exit 1
else
    echo "Using local mcs file..."
fi

# Get zip file
if [ -z ${zip_use_local+x} ]; then
    echo "Getting zip file from ${zip_repo}"

    # Get the zip file asset
    wget -O local_files/${zip_file_name} ${zip_repo}/releases/${zip_repo_tag}/download/${zip_file_name} || exit 1
else
    echo "Using local zip file..."
fi

# Get yml file
if [ -z ${yml_use_local+x} ]; then
    echo "Getting yml file from ${yml_repo}"

    # This repository doesn't use assent, so we need to clone the repository
    # and copy the file we want
    git clone ${yml_repo} -b ${yml_repo_tag} yml_repo || exit 1
    mv yml_repo/defaults/${yml_file_name} local_files || exit 1
    rm -rf yml_repo
else
    echo "Using local yml file..."
fi

# Divide the server argument string into a list of quoted substring, divided by comas.
# This is the format that the Dockerfile uses
server_args_list=$(echo \"${server_args}\" | sed 's/\s/","/g')

# Generate the Dockerfile from the template
cat Dockerfile.template \
        | sed s/%%PYSMURF_SERVER_BASE_VERSION%%/${pysmurf_server_base_version}/g \
        | sed s/%%YML_FILE_NAME%%/${yml_file_name}/g \
        | sed s/%%SERVER_ARGS%%/"${server_args_list}"/g \
        > Dockerfile

# Build the docker image and push it to Dockerhub
docker build -t ${docker_org_name}/${docker_repo} . || exit 1
docker tag ${docker_org_name}/${docker_repo} ${docker_org_name}/${docker_repo}:${TRAVIS_TAG} || exit 1
docker push ${docker_org_name}/${docker_repo}:${TRAVIS_TAG} || exit 1

echo "Docker image '${docker_org_name}/${docker_repo}:${TRAVIS_TAG}' pushed"

# Update the release information
. scripts/generate_release_info.sh
