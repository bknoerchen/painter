#pragma once

#include "polyline.h"

#include "memory"

namespace ShapeFactoryProducts {

std::unique_ptr<Shape> createPolyline(const QPointF & topLeft,
                                      int penWidth,
                                      const QColor & penColor)
{
	return std::unique_ptr<Shape>(new Polyline(topLeft, penWidth, penColor));
}

}
