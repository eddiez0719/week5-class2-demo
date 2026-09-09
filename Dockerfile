# slim base image: smaller footprint, fewer preinstalled packages, smaller attack surface
FROM python:3.12-slim

WORKDIR /app

# don't write .pyc files (smaller image); unbuffered logs (real-time docker logs)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY --chown=10001:10001 app.py /app/app.py   # copy and chown to the non-root user in one step

USER 10001:10001   # run as non-root: least-privilege, limits blast radius if compromised

EXPOSE 5000   # documentation only; actual port mapping is done in compose.yml

CMD ["python", "app.py"]   # exec form: python is PID 1, receives SIGTERM correctly on docker stop
