# Makefile

make: build run

build:
	@echo "Building Kaffeine..."
	@cmake -S . -B build
	@cmake --build build
	@echo "Build complete."

run:
	@echo "Running Kaffeine..."
	@./build/Kaffeine

clean:
	@echo "Cleaning build files..."
	@rm -rf build
	@echo "Clean complete."