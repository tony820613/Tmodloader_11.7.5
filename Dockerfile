# METADATA
FROM debian:testing-slim
LABEL maintainer="KKTony's Docker Lab"

ARG TMOD_VERSION=0.11.7.5
ARG TERRARIA_VERSION=1405

# system update
RUN apt-get -y update &&\
    apt-get -y install wget unzip &&\
    apt-get -y clean

WORKDIR /terraria-server

# get vanilla server
RUN wget "https://terraria.org/system/dedicated_servers/archives/000/000/039/original/terraria-server-1405.zip" &&\
    unzip terraria-server-*.zip &&\
    rm terraria-server-*.zip &&\
    cp --verbose -a "${TERRARIA_VERSION}/Linux/." . &&\
    rm -rf "${TERRARIA_VERSION}"

# add in tModLoader
RUN  wget -qO - "https://github.com/tModLoader/tModLoader/releases/download/v0.11.7.5/tModLoader.Linux.v0.11.7.5.tar.gz" | tar -xvz &&\
    chmod u+x tModLoaderServer* Terraria TerrariaServer.*

# access data directory
RUN ln -s ${HOME}/.local/share/Terraria/ /terraria

# Add default config file
COPY config.txt .

# ports used
EXPOSE 7777

# start server
ENTRYPOINT [ "/terraria-server/tModLoaderServer", "-config", "config.txt" ]

