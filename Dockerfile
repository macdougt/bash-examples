FROM ubuntu:latest

RUN apt-get install -y \
    wget \
    curl \
    expect \
    build-essential \
    perl

RUN curl -L https://cpanmin.us | perl - App::cpanminus

ENV WORKING_DIR /app
RUN mkdir -p $WORKING_DIR
WORKDIR $WORKING_DIR

COPY update_installer ${WORKING_DIR}/update_installer

RUN bash update_installer
RUN yes | bash ./install_t.bash -u=root

RUN apt-get install -y vim

COPY test_env.exp ${WORKING_DIR}/test_env.exp

CMD ["expect","test_env.exp"]
