#include "shapefactory.h"

#include "polyline.h"
#include "rectangle.h"


ShapeFactoryFunction ShapeFactory::getShapeFactoryForProductName(const QString & shapeFactoryProduct) {
	return shapeFactoryProducts_.at(ShapeType::getTypeByName(shapeFactoryProduct));
}

std::unique_ptr<Shape> ShapeFactory::createPolyline(const QPointF & startPoint, int penWidth, const QColor & penColor)
{
	return std::unique_ptr<Shape>(new Polyline(startPoint, penWidth, penColor));
}

std::unique_ptr<Shape> ShapeFactory::createRectangle(const QPointF & startPoint, int penWidth, const QColor & penColor)
{
	return std::unique_ptr<Shape>(new Rectangle(startPoint, penWidth, penColor));
}

const std::map<ShapeType, ShapeFactoryFunction> ShapeFactory::shapeFactoryProducts_ = {
    { ShapeType::Polyline, createPolyline },
    { ShapeType::Rectangle, createRectangle }
};
