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

    TrayIcon tray;

    QObject::connect(tray.getItem(), &KStatusNotifierItem::activateRequested,
                     [](bool active, const QPoint &pos) {
                         qDebug() << "activateRequested fired";
                     });

    QObject::connect(tray.getItem(), &KStatusNotifierItem::secondaryActivateRequested,
                     [](const QPoint &pos) {
                         qDebug() << "secondaryActivateRequested fired";
                     });

    return app.exec();
}