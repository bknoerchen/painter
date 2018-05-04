#include "symmetriccanvasplugin.h"

#include "symmetriccanvas.h"
#include "shapes/shape.h"

#include <qqml.h>

void SymmetricCanvasPlugin::registerTypes(const char * uri)
{
	qmlRegisterType<SymmetricCanvas>(uri, 1, 0, "SymmetricCanvas");

	qRegisterMetaType<ShapeMirrorType>("ShapeMirrorType");
	qmlRegisterUncreatableType<MirrorType>(uri, 1, 0, "ShapeMirrorType", "Not creatable as it is an enum type");
}
