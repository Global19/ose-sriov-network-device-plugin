FROM openshift/origin-release:golang-1.10 as builder

ADD . /usr/src/sriov-network-device-plugin

WORKDIR /usr/src/sriov-network-device-plugin

ENV HTTP_PROXY $http_proxy
ENV HTTPS_PROXY $https_proxy
RUN make clean && \
    make build

FROM openshift/origin-base
COPY --from=builder /usr/src/sriov-network-device-plugin/build/sriovdp /usr/bin/
WORKDIR /

LABEL io.k8s.display-name="SRIOV Network Device Plugin"

ADD ./images/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
