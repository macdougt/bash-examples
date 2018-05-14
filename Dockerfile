FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    wget

ENV WORKING_DIR /app
RUN mkdir -p $WORKING_DIR
WORKDIR $WORKING_DIR

COPY update_installer ${WORKING_DIR}/update_installer

RUN bash update_installer
RUN yes | bash ./install_t.bash -u=root
