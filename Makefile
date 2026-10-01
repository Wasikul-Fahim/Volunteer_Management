.PHONY: up down logs backend-test migrate makemigration lint seed

up:
	docker compose up --build

down:
	docker compose down

logs:
	docker compose logs -f

backend-test:
	set -a; [ ! -f .env ] || . ./.env; set +a; cd backend && pytest

migrate:
	set -a; [ ! -f .env ] || . ./.env; set +a; cd backend && alembic upgrade head

makemigration:
	set -a; [ ! -f .env ] || . ./.env; set +a; cd backend && alembic revision --autogenerate -m "$(m)"

lint:
	set -a; [ ! -f .env ] || . ./.env; set +a; cd backend && ruff check app

seed:
	python scripts/seed.py
