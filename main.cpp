#ifdef QT_ANDROIDEXTRAS_LIB
#include "androidfiledialog.h"
#endif

#include "cppcontroller.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QDebug>

int main(int argc, char *argv[])
{
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

	//engine.addImportPath("/home/basti/source/Painter/bin/debug/PainterCanvas");
	qDebug() << engine.importPathList();
	engine.load(mainQml);
	CppController * cc = new CppController();
	engine.rootContext()->setContextProperty("_cppController", cc);


#ifdef QT_ANDROIDEXTRAS_LIB
	AndroidFileDialog * afd = new AndroidFileDialog();
	engine.rootContext()->setContextProperty("_androidFileDialog", afd);
#endif

	return app.exec();
}
