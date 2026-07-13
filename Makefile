PLUGIN_ID := org.kde.kaffeine

dev-install:
	@echo "Building $(PLUGIN_ID)..."
	@cmake -B build -S . -DQT_MAJOR_VERSION=6
	@echo "Checking QML syntax..."
	@qmllint package/contents/ui/main.qml
	@echo "Installing $(PLUGIN_ID)..."
	@kpackagetool6 --install package --type Plasma/Applet \
		|| kpackagetool6 --upgrade package --type Plasma/Applet
	@echo "Installation complete."

dev-uninstall:
	@echo "Uninstalling $(PLUGIN_ID)..."
	@rm -rf build
	@rm -rf ~/.local/share/plasma/plasmoids/org.kde.kaffeine
	@echo "Uninstallation complete."

dev-reinstall: dev-uninstall dev-install
	@echo "Restarting plasmashell..."
	@kquitapp6 plasmashell 2>/dev/null; kstart6 plasmashell > /dev/null 2>&1 &

dev-test:
	@qmllint package/contents/ui/main.qml
	@plasmoidviewer -a package

plasmoid:
	@echo "Turning the package into a plasmoid..."
	@rm -f kaffeine.plasmoid
	@if zip -r kaffeine.plasmoid package/; then \
		echo "Plasmoid created successfully."; \
	else \
		echo "Failed to create plasmoid."; \
	fi