dev:
	docker-compose -f docker-compose-dev.yml up

test:
	pytest

cov:
	pytest --cov=app tests/

lint:
	ruff app tests

typecheck:
	mypy app