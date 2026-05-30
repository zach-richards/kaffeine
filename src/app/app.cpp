// app.cpp

#include <QApplication>

QApplication initializeApp(int argc, char *argv[]) {
    QApplication app(argc, argv);
    app.setApplicationName("Kaffeine");
    app.setOrganizationName("KDE");

    return app;
}