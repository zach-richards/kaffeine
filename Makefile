# Makefile

all: build run

build:
	@echo "Building Caffeine..."
	@cmake -S . -B build
	@cmake --build build
	@echo "Build complete."

rebuild: clean build

run:
	@echo "Running Caffeine..."
	@./build/Caffeine

clean:
	@echo "Cleaning build files..."
	@rm -rf build
	@echo "Clean complete."