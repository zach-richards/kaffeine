PLUGIN_ID := org.kde.kaffeine

dev-install:
	@echo "Installing $(PLUGIN_ID)..."
	@kpackagetool6 --install package --type Plasma/Applet \
		|| kpackagetool6 --upgrade package --type Plasma/Applet
	@echo "Installation complete."

dev-uninstall:
	@echo "Uninstalling $(PLUGIN_ID)..."
	@rm -rf ~/.local/share/plasma/plasmoids/org.kde.kaffeine
	@echo "Uninstallation complete."
	@echo "Restarting plasmashell..."
	@plasmashell --replace &

dev-reinstall: dev-uninstall dev-install

plasmoid:
	@echo "Turning the package into a plasmoid..."
	@rm -f kaffeine.plasmoid
	@if zip -r kaffeine.plasmoid package/; then \
		echo "Plasmoid created successfully."; \
	else \
		echo "Failed to create plasmoid."; \
	fi