# Makefile

make all: build

build:
	@echo "Building the project..."
	cmake -B main
	cmake --build main