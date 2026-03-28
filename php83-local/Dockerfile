# Global build args
ARG COMPOSER_VERSION=2
ARG NODE_MAJOR=18
ARG PHP_VERSION=8.3-apache

# Composer stage
FROM composer:${COMPOSER_VERSION} AS composer-image

# Node stage
FROM node:${NODE_MAJOR}-bullseye AS node-image

# Main dev image
FROM php:${PHP_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# --------------------------------------------------
# Build args
# --------------------------------------------------
ARG TZ=Europe/Berlin
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

ARG XDEBUG_VERSION=3.5.1
ARG NODE_MAJOR=18
ARG EDGE_DRIVER_VERSION=146.0.3856.62
ARG MAVEN_VERSION=3.9.12
ARG FLYWAY_VERSION=11.1.1

ENV TZ="${TZ}" \
    DISPLAY=:99 \
    DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------
# Timezone
# --------------------------------------------------
RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime \
 && echo "${TZ}" > /etc/timezone

# --------------------------------------------------
# User (for dev containers / vscode)
# --------------------------------------------------
RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
 && useradd -m -u "${USER_UID}" -g "${USER_GID}" -s /bin/bash "${USERNAME}"

# --------------------------------------------------
# System dependencies + PHP extensions
# --------------------------------------------------
RUN docker-apt-clean-install \
      ca-certificates \
      curl \
      git \
      gnupg \
      unzip \
      wget \
      nano \
      mariadb-client \
      python3-click \
      python3-colorama \
      python3-git \
      libfreetype6-dev \
      libicu-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libzip-dev \
      libonig-dev \
      firefox-esr \
      xvfb \
      x11-utils \
      x11-xserver-utils \
      chromium \
      chromium-driver \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j"$(nproc)" \
      intl \
      gd \
      pdo \
      pdo_mysql \
      zip \
      calendar \
 && ln -sf /usr/bin/firefox-esr /usr/bin/firefox

# --------------------------------------------------
# Xdebug
# --------------------------------------------------
RUN pecl install xdebug-"${XDEBUG_VERSION}" \
 && docker-php-ext-enable xdebug

# --------------------------------------------------
# Microsoft Edge + WebDriver (external script)
# --------------------------------------------------
COPY php83-local/scripts/install-edge.sh /usr/local/bin/install-edge
RUN chmod +x /usr/local/bin/install-edge \
 && install-edge

# --------------------------------------------------
# Apache modules
# --------------------------------------------------
RUN a2enmod rewrite proxy_fcgi alias headers ssl

# --------------------------------------------------
# Self-signed SSL certificate
# --------------------------------------------------
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=DE/ST=Dev/L=Dev/O=Dev/OU=Dev/CN=localhost"

# --------------------------------------------------
# SSL VirtualHost
# --------------------------------------------------
COPY php83-local/apache-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl

# --------------------------------------------------
# Composer
# --------------------------------------------------
COPY --from=composer-image /usr/bin/composer /usr/bin/composer

# --------------------------------------------------
# Node from multi-stage
# --------------------------------------------------
COPY --from=node-image /usr/local/bin/node /usr/local/bin/node
COPY --from=node-image /usr/local/lib/node_modules /usr/local/lib/node_modules

# --------------------------------------------------
# Java 21 (Temurin)
# --------------------------------------------------
RUN apt-get update \
 && apt-get install -y --no-install-recommends gnupg \
 && curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public \
    | gpg --batch --no-tty --dearmor -o /usr/share/keyrings/adoptium.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo $VERSION_CODENAME) main" \
    > /etc/apt/sources.list.d/adoptium.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends temurin-21-jdk \
 && ln -sf /usr/lib/jvm/temurin-21-jdk-$(dpkg --print-architecture)/bin/java /usr/local/bin/java \
 && ln -sf /usr/lib/jvm/temurin-21-jdk-$(dpkg --print-architecture)/bin/javac /usr/local/bin/javac \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# Maven
# --------------------------------------------------
RUN curl -fsSL -o /tmp/maven.tar.gz \
      "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
 && curl -fsSL -o /tmp/maven.tar.gz.sha512 \
      "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512" \
 && echo "$(cat /tmp/maven.tar.gz.sha512)  /tmp/maven.tar.gz" | sha512sum -c - \
 && tar -xzf /tmp/maven.tar.gz -C /opt \
 && ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn \
 && rm -f /tmp/maven.tar.gz /tmp/maven.tar.gz.sha512

# --------------------------------------------------
# Flyway CLI
# --------------------------------------------------
RUN curl -fsSL -o /tmp/flyway.tar.gz \
      "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz" \
 && curl -fsSL -o /tmp/flyway.tar.gz.sha1 \
      "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz.sha1" \
 && echo "$(cat /tmp/flyway.tar.gz.sha1)  /tmp/flyway.tar.gz" | sha1sum -c - \
 && tar -xzf /tmp/flyway.tar.gz -C /opt \
 && ln -s /opt/flyway-${FLYWAY_VERSION}/flyway /usr/local/bin/flyway \
 && rm -f /tmp/flyway.tar.gz /tmp/flyway.tar.gz.sha1


# --------------------------------------------------
# App setup
# --------------------------------------------------
WORKDIR /var/www/html
COPY php83-local/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

EXPOSE 80