FROM docker:17.12.0-ce-git

RUN addgroup -g 1001 terraform && \
    adduser -u 1001 -G terraform -s /bin/sh -D terraform && \
    apk upgrade -v --no-cache && \
        apk -v --no-cache --update add \
        bash \
        ca-certificates \
        curl \
        groff \
        jq \
        less \
        mailcap \
        make \
        py-pip \
        python \
        tar \
        && \
        pip install --upgrade --no-cache-dir pip awscli s3cmd python-magic docker-compose && \
#        curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
#        -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
#        unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
#        rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        apk -v --purge del py-pip && \
        rm /var/cache/apk/* && \
        mkdir -p /home/terraform/bin && chown terraform:terraform -R /home/terraform

RUN apk add --update nodejs
