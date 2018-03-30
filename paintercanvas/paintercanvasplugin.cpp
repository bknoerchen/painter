#include "paintercanvasplugin.h"

#include "paintercanvas.h"
#include <qqml.h>

void PainterCanvasPlugin::registerTypes(const char *uri)
{
	qmlRegisterType<PainterCanvas>(uri, 1, 0, "PainterCanvas");
}
