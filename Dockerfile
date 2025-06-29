# syntax=docker/dockerfile:1

# Use a Python slim image based on Bookworm
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copy uv and uvx binaries from the official uv image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy all project files into the container
COPY . .

# Create a virtual environment
RUN uv venv

# Install dependencies from the lock file into the venv
RUN uv sync --locked

# Install the project itself into the venv
RUN uv pip install .

# Add the venv to the PATH to make binaries available
ENV PATH="/app/.venv/bin:$PATH"
ENV VIRTUAL_ENV="/app/.venv"

# Command to start the MCP server using uvx
CMD ["mcp-multilspy"]