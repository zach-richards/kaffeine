// main.cpp

#include "src/app/app.cpp"
#include "src/app/tray_icon.cpp"

int main() {
    int argc = 0;
    char *argv[] = { nullptr };
    QApplication app(argc, argv);

    initializeApp(app);

    TrayIcon trayIcon;

    return app.exec();
}