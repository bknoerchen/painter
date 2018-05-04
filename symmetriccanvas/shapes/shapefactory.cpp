#include "shapefactory.h"

#include "polyline.h"
#include "rectangle.h"
#include "ellipse.h"


ShapeFactoryFunction ShapeFactory::getShapeFactoryForProductName(const QString & shapeFactoryProduct) {
	return shapeFactoryRegistration_.at(ShapeType::getTypeByName(shapeFactoryProduct));
}

const std::map<ShapeType, ShapeFactoryFunction> ShapeFactory::shapeFactoryRegistration_ = {
    { ShapeType::Polyline,  create<Polyline> },
    { ShapeType::Rectangle, create<Rectangle> },
    { ShapeType::Ellipse,   create<Ellipse> }
};

template<typename ShapeType>
std::unique_ptr<Shape> ShapeFactory::create(const QPointF & startPoint, int penWidth, int symmetryCount, const QColor & penColor)
{
	return std::unique_ptr<Shape>(new ShapeType(startPoint, penWidth, symmetryCount, penColor));
}
