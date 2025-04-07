dev:
	docker-compose up --build

test:
	pytest

cov:
	pytest --cov=app tests/

lint:
	ruff app tests

typecheck:
	mypy app