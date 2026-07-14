PLUGIN_ID := org.kde.kaffeine

.PHONY: dev-install dev-uninstall dev-reinstall dev-test plasmoid clean

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
	@rm -rf ~/.local/share/plasma/plasmoids/$(PLUGIN_ID)
	@echo "Uninstallation complete."

dev-reinstall: dev-uninstall dev-install
	@echo "Restarting plasmashell..."
	@kquitapp6 plasmashell 2>/dev/null; sleep 1; kstart6 plasmashell > /dev/null 2>&1 &
	@plasmashell --replace > /dev/null 2>&1 &

dev-test: dev-reinstall
	@echo "Launching $(PLUGIN_ID) in plasmoidviewer..."
	@QT_LOGGING_RULES="qml=true" plasmoidviewer -a org.kde.kaffeine

plasmoid:
	@echo "Turning the package into a plasmoid..."
	@rm -f kaffeine.plasmoid
	@if zip -r kaffeine.plasmoid package/; then \
		echo "Plasmoid created successfully."; \
	else \
		echo "Failed to create plasmoid."; \
	fi

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build
	@rm -f kaffeine.plasmoid
	@echo "Clean complete."