setup:

test:
    uvx pytest tests

lint:
    uvx ruff check .
    uvx ruff format --check .
    uvx pyright

lint-fix:
    uvx ruff check . --fix
    uvx ruff format .

run:
    uv run mcp-multilspy

dev:
    uvx mcp dev -m mcp_multilspy

install:
    uvx mcp install -m mcp_multilspy

clean:
    rm -rf .venv target dist *.egg-info
    find . -type d -name "__pycache__" -exec rm -rf {} +
    rm -rf .mcp_server
