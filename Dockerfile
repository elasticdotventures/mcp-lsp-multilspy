# syntax=docker/dockerfile:1

# Stage 1: Build the virtual environment with project dependencies
FROM ghcr.io/astral-sh/uv:latest-python3.12 AS builder

WORKDIR /app

# Copy project definition and lock files
COPY pyproject.toml uv.lock ./

# Create a virtual environment
RUN uv venv

# Install dependencies from the lock file into the venv
RUN .venv/bin/uv sync --locked

# Copy the rest of the application code
COPY . .

# Install the project itself into the venv
RUN .venv/bin/uv pip install --no-deps .


# Stage 2: Build the final, minimal image
FROM python:3.12-slim AS final

WORKDIR /app

# Copy the uv binary from the official distroless image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy the virtual environment from the builder stage
COPY --from=builder /app/.venv ./.venv

# Copy the application source code
COPY --from=builder /app/src ./src

# Add the venv to the PATH to make binaries available
ENV PATH="/app/.venv/bin:$PATH"

# Command to start the MCP server using uvx
CMD ["uvx", "mcp-multilspy"]
