// main.cpp

#include "include/app/app.h"
#include "include/app/tray_icon.h"

int main() {
    int argc = 0;
    char *argv[] = { nullptr };
    QApplication app(argc, argv);

    initializeApp(app);

    TrayIcon trayIcon;

    qSetMessagePattern("%{file}:%{line} - %{message}");
    return app.exec();
}