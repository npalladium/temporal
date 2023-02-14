FROM alpine:3.17 as builder

ARG RELEASE_VERSION=v0.3.0
ARG RELEASE_TARBALL=temporalite_0.3.0_linux_amd64.tar.gz

# hadolint ignore=DL3018
RUN apk add --quiet --no-cache wget \
    && wget --quiet "https://github.com/temporalio/temporalite/releases/download/${RELEASE_VERSION}/${RELEASE_TARBALL}" \
    && tar -xzf ${RELEASE_TARBALL}

FROM gcr.io/distroless/static-debian11:nonroot

COPY --from=builder /temporalite /bin
EXPOSE 8233

ENTRYPOINT ["/bin/temporalite", "start", "--ephemeral", "-n", "default", "--ip" , "0.0.0.0"]
