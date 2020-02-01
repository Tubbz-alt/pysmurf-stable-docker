FROM tidair/pysmurf-server-base:v4.0.0-rc15

# Prepare directory to hold FW and config file
RUN mkdir -p /tmp/fw/ && chmod -R a+rw /tmp/fw/

# Copy all firmware related files, which are in the local_files directory
COPY local_files/*.mcs.gz /tmp/fw/
COPY local_files/*.zip    /tmp/fw/
COPY local_files/*.yml    /tmp/fw/

WORKDIR /
ARG yml_file_name
ARG server_args
CMD ["-d","/tmp/fw/defaults_lbonly_c03_bay0.yml",--disable-bay1]
