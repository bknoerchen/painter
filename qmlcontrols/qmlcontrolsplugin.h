#include <QQmlExtensionPlugin>
#include <qqml.h>

class QmlControlsPlugin : public QQmlExtensionPlugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
	QmlControlsPlugin(QObject *parent = 0) : QQmlExtensionPlugin(parent) {
		Q_INIT_RESOURCE(qmlcontrols);
	}

	virtual void registerTypes(const char * uri)
	{
		Q_ASSERT(QLatin1String(uri) == QLatin1String("QmlControls"));
		Q_UNUSED(uri);
	}
};
