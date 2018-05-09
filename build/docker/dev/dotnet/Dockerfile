FROM microsoft/dotnet:2.0.0-sdk

# add docker user and setup folders
RUN addgroup --gid 999 docker && \
    adduser --uid 2002 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker && \
    mkdir -p /dotnet && \
    chown -R docker:docker /dotnet

# install fixuid
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.2/fixuid-0.2-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

# set entrypoint and command
ENTRYPOINT ["fixuid"]
CMD ["app-run"]

# copy staged files
COPY stage/ /

# set user
USER docker:docker
