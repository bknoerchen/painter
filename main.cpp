#ifdef QT_ANDROIDEXTRAS_LIB
#include "androidfiledialog.h"
#endif

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;

	const QUrl mainQml(QStringLiteral("qrc:/main.qml"));

	// Catch the objectCreated signal, so that we can determine if the root component was loaded
	// successfully. If not, then the object created from it will be null. The root component may
	// get loaded asynchronously.
	const QMetaObject::Connection connection = QObject::connect(
	                                               &engine, &QQmlApplicationEngine::objectCreated,
	                                               &app, [&](QObject *object, const QUrl &url) {
	                                           if (url != mainQml)
	                                           return;

	                                           if (!object)
	                                           app.exit(-1);
	                                           else
	                                           QObject::disconnect(connection);
}, Qt::QueuedConnection);

	engine.load(mainQml);

#ifdef QT_ANDROIDEXTRAS_LIB
	AndroidFileDialog * afd = new AndroidFileDialog();
	engine.rootContext()->setContextProperty("_androidFileDialog", afd);
#endif

	return app.exec();
}
