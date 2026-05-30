// main.cpp

#include "src/app/app.cpp"
#include "src/app/tray_icon.cpp"

int main()
{
    int argc = 0;
    char *argv[] = { nullptr };

    QApplication app = initializeApp(argc, argv);
    TrayIcon trayIcon;

    return app.exec();
}