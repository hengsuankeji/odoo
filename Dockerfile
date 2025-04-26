FROM ubuntu:noble AS builder

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG=en_US.UTF-8

# Retrieve the target architecture to install the correct wkhtmltopdf package
ARG TARGETARCH

# Install only essential build dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    libssl-dev \
    python3-pip \
    python3-venv \
    python3-dev \
    libpq-dev \
    build-essential \
    libldap2-dev \
    libsasl2-dev \
    node-less \
    npm \
    xz-utils && \
    if [ -z "${TARGETARCH}" ]; then \
    TARGETARCH="$(dpkg --print-architecture)"; \
    fi; \
    WKHTMLTOPDF_ARCH=${TARGETARCH} && \
    case ${TARGETARCH} in \
    "amd64") WKHTMLTOPDF_ARCH=amd64 && WKHTMLTOPDF_SHA=967390a759707337b46d1c02452e2bb6b2dc6d59  ;; \
    "arm64")  WKHTMLTOPDF_SHA=90f6e69896d51ef77339d3f3a20f8582bdf496cc  ;; \
    "ppc64le" | "ppc64el") WKHTMLTOPDF_ARCH=ppc64el && WKHTMLTOPDF_SHA=5312d7d34a25b321282929df82e3574319aed25c  ;; \
    esac \
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_${WKHTMLTOPDF_ARCH}.deb \
    && echo ${WKHTMLTOPDF_SHA} wkhtmltox.deb | sha1sum -c - \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && npm install -g rtlcss \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb /tmp/* /var/tmp/*

# Setup virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements first for better caching
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    pip3 cache purge

# Second stage - final image
FROM ubuntu:noble

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]
ENV LANG=en_US.UTF-8
ARG TARGETARCH

# Install only runtime dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    fonts-noto-cjk \
    libssl-dev \
    node-less \
    npm \
    python3-magic \
    python3-num2words \
    python3-odf \
    python3-pdfminer \
    python3-phonenumbers \
    python3-pyldap \
    python3-qrcode \
    python3-renderpm \
    python3-slugify \
    python3-vobject \
    python3-watchdog \
    python3-xlrd \
    python3-xlwt \
    python3 \
    postgresql-client \
    libpq5 \
    wkhtmltopdf && \
    npm install -g rtlcss && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # Create Odoo user
    useradd -md /home/odoo -s /bin/false odoo && \
    mkdir -p /mnt/extra-addons /var/lib/odoo /etc/odoo && \
    chown -R odoo:odoo /mnt/extra-addons /var/lib/odoo /etc/odoo

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy Odoo files
COPY --chown=odoo:odoo entrypoint.sh /entrypoint.sh
COPY --chown=odoo:odoo wait-for-psql.py /usr/local/bin/wait-for-psql.py
COPY --chown=odoo:odoo ./odoo.conf /etc/odoo/

# Copy only necessary Odoo source files, excluding .git directories and other unnecessary files
WORKDIR /opt/odoo
COPY --chown=odoo:odoo ./addons /opt/odoo/addons
COPY --chown=odoo:odoo ./odoo /opt/odoo/odoo
COPY --chown=odoo:odoo ./odoo-bin /opt/odoo/

RUN chmod +x /entrypoint.sh /usr/local/bin/wait-for-psql.py

# Odoo data volumes
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
ENV ODOO_RC=/etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]