# messageHandler.cpp

#include <QMessageLogContext>
#include <QString>

void messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg) {
    if (msg.contains("Empty key passed")) return;
    switch (type) {
        case QtDebugMsg:    fprintf(stderr, "Debug: %s\n", msg.toLocal8Bit().constData()); break;
        case QtWarningMsg:  fprintf(stderr, "Warning: %s\n", msg.toLocal8Bit().constData()); break;
        case QtCriticalMsg: fprintf(stderr, "Critical: %s\n", msg.toLocal8Bit().constData()); break;
        case QtFatalMsg:    fprintf(stderr, "Fatal: %s\n", msg.toLocal8Bit().constData()); break;
        default: break;
    }
}