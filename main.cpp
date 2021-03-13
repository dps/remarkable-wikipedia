#include <QGuiApplication>
#include <QQmlApplicationEngine>
// Added for reMarkable support
#include <QtPlugin>
#ifdef __arm__
Q_IMPORT_PLUGIN(QsgEpaperPlugin)
#endif
// end reMarkable additions
#include <QtDBus>

#include "eventfilter.h"

using namespace std;

int main(int argc, char *argv[])
{
    //  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    // Added for reMarkable support
#ifdef __arm__
    qputenv("QMLSCENE_DEVICE", "epaper");
    qputenv("QT_QPA_PLATFORM", "epaper:enable_fonts");
    qputenv("QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS", "rotate=180");
    qputenv("QT_QPA_GENERIC_PLUGINS", "evdevtablet");
#endif
    // end reMarkable additions

    QGuiApplication app(argc, argv);
    auto filter = new EventFilter(&app);
    app.setOrganizationName("dps");
    app.setOrganizationDomain("io.singleton.wikipedia");
    app.setApplicationName("wikipedia");
    app.setApplicationDisplayName("wikipedia");
    app.installEventFilter(filter);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    QObject* root = engine.rootObjects().first();
    filter->root = (QQuickItem*)root;

    return app.exec();
}
