PLUGIN_ID := org.kde.kaffeine

dev-install:
	kpackagetool6 --install package --type Plasma/Applet \
	    || kpackagetool6 --upgrade package --type Plasma/Applet

dev-uninstall:
	kpackagetool6 --remove --type Plasma/Applet $(PLUGIN_ID)

plasmoid:
	@echo "Turning the package into a plasmoid..."
	@rm -f kaffeine.plasmoid
	@if zip -r kaffeine.plasmoid package/; then \
	    echo "Plasmoid created successfully."; \
	else \
	    echo "Failed to create plasmoid."; \
	fi