FROM quay.io/monax/build:0.16
MAINTAINER Monax <support@monax.io>

# Install monax-keys, a go app for development signing
ENV TARGET monax-keys
ENV REPO $GOPATH/src/github.com/monax/keys

# required for testing; should be removed
RUN apk --no-cache --update add openssl

ADD ./glide.yaml $REPO/
ADD ./glide.lock $REPO/
WORKDIR $REPO
RUN glide install

COPY . $REPO/.
RUN cd $REPO/cmd/$TARGET && \
  go build --ldflags '-extldflags "-static"' -o $INSTALL_BASE/$TARGET

# build customizations start here
# install mint-key [to be deprecated]
# NOTE: repo must remain [eris-ltd] to Godep reasons
ENV MONAX_KEYS_MINT_REPO github.com/eris-ltd/mint-client
ENV MONAX_KEYS_MINT_SRC_PATH $GOPATH/src/$MONAX_KEYS_MINT_REPO

WORKDIR $MONAX_KEYS_MINT_SRC_PATH

RUN git clone --quiet https://$MONAX_KEYS_MINT_REPO . \
  && git checkout --quiet master \
  && go build --ldflags '-extldflags "-static"' -o $INSTALL_BASE/mintkey ./mintkey \
  && unset MONAX_KEYS_MINT_REPO \
  && unset MONAX_KEYS_MINT_SRC_PATH
