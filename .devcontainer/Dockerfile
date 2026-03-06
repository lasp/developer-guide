FROM mcr.microsoft.com/devcontainers/base:alpine-3.22

ENV POETRY_HOME=/opt/poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="${PATH}:${POETRY_HOME}/bin"
