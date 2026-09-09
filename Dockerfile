# slim base image: smaller footprint, fewer preinstalled packages, smaller attack surface
FROM python:3.12-slim

WORKDIR /app

# don't write .pyc files (smaller image); unbuffered logs (real-time docker logs)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# copy and chown to the non-root user in one step
COPY --chown=10001:10001 app.py /app/app.py

# run as non-root: least-privilege, limits blast radius if compromised
USER 10001:10001

# documentation only; actual port mapping is done in compose.yml
EXPOSE 5000

# exec form: python is PID 1, receives SIGTERM correctly on docker stop
CMD ["python", "app.py"]
