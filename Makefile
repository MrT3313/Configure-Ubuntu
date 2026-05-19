.PHONY: executable run run-preserve-favorites

executable:
	find . -name '*.sh' -exec chmod +x {} +

run: executable
	./setup-environment.sh

run-preserve-favorites: executable
	./setup-environment.sh --preserve-favorites
