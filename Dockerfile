FROM python:3.10.7-slim-buster as python
ENV PYTHONUNBUFFERED=true
WORKDIR /app


FROM python as poetry
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV PATH="$POETRY_HOME/bin:$PATH"
RUN python -c 'from urllib.request import urlopen; print(urlopen("https://install.python-poetry.org").read().decode())' | python -
COPY . ./
RUN poetry install --no-interaction --no-ansi -vvv



FROM python as runtime
LABEL org.opencontainers.image.source="https://github.com/AbsolutOD/AbsolutOD/demo-url-shortener"

ENV PATH="/app/.venv/bin:$PATH"
COPY --from=poetry /app /app
EXPOSE 80
CMD [ "uvicorn", "shortener_app.main:app", "--host", "0.0.0.0", "--port", "80" ]
