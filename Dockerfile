ARG DEBIAN_VERSION="trixie-slim"
FROM debian:${DEBIAN_VERSION}

RUN apt update && \
	apt install -y curl && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

# Create user
ARG USER_ID="10000"
ARG GROUP_ID="10001"
ARG USER_NAME="pythonista"
RUN groupadd -g "${GROUP_ID}" "${USER_NAME}" && \
	useradd -l -u "${USER_ID}" -m "${USER_NAME}" -g "${USER_NAME}"

USER ${USER_NAME}

WORKDIR /home/${USER_NAME}/app

# Install rye
ENV RYE_HOME /home/${USER_NAME}/.rye
ENV PATH ${RYE_HOME}/shims:${PATH}
RUN curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash \
	&& rye config --set-bool behavior.use-uv=true

# Install packages
COPY README.md .python-version pyproject.toml requirements*.lock ./
RUN rye sync --no-dev --no-lock

COPY app ./app

CMD [ "rye", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80" ]
