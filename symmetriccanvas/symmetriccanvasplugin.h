#pragma once

#include <QQmlExtensionPlugin>

class SymmetricCanvasPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
	virtual void registerTypes(const char * uri);
};
