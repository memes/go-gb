# Builds a container that will build a gb (http://getgb.io/) project
# in a consistent Go version

FROM golang:1.5
MAINTAINER Matthew Emes <memes@matthewemes.com>

# Make sure that git (should be there), hg and bzr are installed so
# that vendor directory can be restored from repos
RUN apt-get update && \
    apt-get install -y --no-install-recommends git mercurial bzr && \
    rm -rf /var/lib/apt/lists/*
    
# Install specified version of gb from source
ENV GB_VER v0.2.0
RUN mkdir -p $GOPATH/src/github.com/constabulary && \
    cd $GOPATH/src/github.com/constabulary && \
    git clone https://github.com/constabulary/gb.git && \
    cd gb && \
    git checkout $GB_VER && \
    go install ./...

# Add build script
COPY go-gb.sh /usr/local/bin/go-gb.sh
RUN chmod 0755 /usr/local/bin/go-gb.sh

# Create a safe place to do builds...
RUN /usr/sbin/adduser --gecos Builder --disabled-login builder && \
    mkdir -p /home/builder/project /home/builder/.ssh

# Optional; copy SSH keys and configuration to builder account; only
# needed if need to refresh vendor directory using an authenticated
# account. Most of the time the .ssh directory can be empty, as can .gitconfig
COPY .ssh/ /home/builder/.ssh/
COPY .gitconfig /home/builder/
RUN chown -R builder:builder /home/builder && \
    chmod 0700 /home/builder/.ssh && \
    chmod 0600 /home/builder/.ssh/* && \
    chmod 0640 /home/builder/.ssh/*pub || true

# Export the builder project folder as a volume
VOLUME /home/builder/project

# Switch to builder account and execute a gb build in /home/builder/project
USER builder
WORKDIR /home/builder/project
ENTRYPOINT ["/usr/local/bin/go-gb.sh"]
