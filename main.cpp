// main.cpp

#include "include/warningHandler.h"
#include "include/app/app.h"
#include "include/app/trayIcon.h"

int main() {
    qInstallMessageHandler(warningHandler);
    
    int argc = 0;
    char *argv[] = { nullptr };
    QApplication app(argc, argv);

    initializeApp(app);

    TrayIcon trayIcon;

    return app.exec();
}