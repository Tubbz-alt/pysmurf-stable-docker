#!/usr/bin/env bash

# Release information:

## Release name
release_name="${DOCKERHUB_ORG_NAME}/${DOCKERHUB_REPO}:${tag}"

## Release description and New entry on the RELEASE.md file
release_description="- **pysmurf-server-base:** [${pysmurf_server_base_version}](${pysmurf_repo}/releases/tag/${pysmurf_server_base_version})"
release_new_row="${tag} | ${pysmurf_server_base_version} | "

release_description+="
- **MCS file:** "
release_new_row+="${mcs_file_name} "
if [ -z ${mcs_use_local+x} ]; then
    release_description+="[${mcs_file_name}](${mcs_repo}/releases/download/${mcs_repo_tag}/${mcs_file_name}) (tag [${mcs_repo_tag}](${mcs_repo}/releases/tag/${mcs_repo_tag}))"
    release_new_row+="(${mcs_repo_tag}) | "
else
    release_description+="Local copy [${mcs_file_name}](https://github.com/${REPO_SLUG}/blob/${tag}/local_files/${mcs_file_name})"
    release_new_row+="(local copy) | "
fi

release_description+="
- **ZIP file:** "
release_new_row+="${zip_file_name} "
if [ -z ${zip_use_local+x} ]; then
    release_description+="[${zip_file_name}](${zip_repo}/releases/download/${zip_repo_tag}/${zip_file_name}) (tag [${zip_repo_tag}](${zip_repo}/releases/tag/${zip_repo_tag}))"
    release_new_row+="(${zip_repo_tag}) | "
else
    release_description+="Local copy [${zip_file_name}](https://github.com/${REPO_SLUG}/blob/${tag}/local_files/${zip_file_name})"
    release_new_row+="(local copy) | "
fi

release_description+="
- **YML file:** "
if [ -z ${yml_use_local+x} ]; then
    if [ -z ${yml_file_name} ]; then
        release_description+="Full repo ${yml_repo}"
        release_new_row+="Full repo (${yml_repo_tag}) | "
    else
        release_description+="[${yml_file_name}](${yml_repo}/blob/${yml_repo_tag}/defaults/${yml_file_name})"
        release_new_row+="${yml_file_name} (${yml_repo_tag}) | "
    fi
    release_description+=" (tag [${yml_repo_tag}](${yml_repo}/releases/tag/${yml_repo_tag}))"
else
    release_description+="Local copy [${yml_file_name}](https://github.com/${REPO_SLUG}/blob/${tag}/local_files/${yml_file_name})"
    release_new_row+="(local copy) | "
fi

release_description+="
- **Server arguments:** "
if ! [ -z "${server_args}" ]; then
    release_description+="\\\`${server_args}\\\`"
fi
release_new_row+="${server_args}"


## Write results to an output file
cat << EOF > vars.env
release_name="${release_name}"
release_description="${release_description}"
release_new_row="${release_new_row}"
EOF
