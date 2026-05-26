.PHONY: help up down build logs migrate dev-backend dev-frontend clean env

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}{printf "\033[36m%-20s\033[0m %s\n",$$1,$$2}'

up:            ## Start all containers
	docker compose up -d

down:          ## Stop all containers
	docker compose down

build:         ## Rebuild all images
	docker compose build --no-cache

logs:          ## Tail all container logs
	docker compose logs -f

logs-backend:  ## Tail backend logs
	docker compose logs -f backend

migrate:       ## Run database migrations
	docker compose exec backend alembic upgrade head

shell:         ## Open backend shell
	docker compose exec backend bash

dev-backend:   ## Run backend locally (needs venv)
	cd backend && uvicorn app.main:app --reload --port 8000

dev-frontend:  ## Run frontend locally with hot reload
	cd frontend && npm run dev

clean:         ## Remove build artifacts and volumes
	docker compose down -v
	rm -rf frontend/dist frontend/node_modules
	find backend -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true

env:           ## Create .env from example (safe)
	@test -f .env && echo ".env already exists" || (cp .env.example .env && echo "Created .env — fill in your values!")
