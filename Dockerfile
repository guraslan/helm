FROM alpine:edge

# variable "VERSION" must be passed as docker environment variables during the image build
# docker build --no-cache --build-arg VERSION=2.12.0 -t alpine/helm:2.12.0 .

ARG VERSION

ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
#ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${VERSION}-linux-amd64.tar.gz"

RUN apk add --update --no-cache curl ca-certificates && \
    curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    curl -o /usr/bin/aws-iam-authenticator \
           https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator && \
    curl -o /usr/bin/kubectl \
        -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl && \
    rm -rf linux-amd64 && \
    apk del curl && \
    rm -f /var/cache/apk/*

WORKDIR /apps

CMD ["helm", "--help"]
