#include "symmetriccanvasplugin.h"

#include "symmetriccanvas.h"
#include <qqml.h>

void SymmetricCanvasPlugin::registerTypes(const char * uri)
{
	qmlRegisterType<SymmetricCanvas>(uri, 1, 0, "SymmetricCanvas");
}
