// main.cpp
#include "include/warningHandler.h"
#include "include/app/app.h"
#include "include/app/trayIcon.h"
#include <QApplication>
#include <KStatusNotifierItem>
#include <QDebug>

int main(int argc, char *argv[]) {
    qInstallMessageHandler(warningHandler);
    QApplication app(argc, argv);

    initializeApp(app);

    TrayIcon tray;

    return app.exec();
}