#pragma once

#include "shape.h"

#include <QMetaEnum>
#include <QMetaObject>

#include "functional"
#include "memory"


typedef std::function<std::unique_ptr<Shape>(const QPointF &, int, int, const QColor &)> ShapeFactoryFunction;

class ShapeType {
	Q_GADGET
	Q_ENUMS(Type)
public:
	enum Type {
		None = -1,
		Polyline,
		Rectangle,
		Ellipse,
	};

	ShapeType(const Type & shapeType = None) : shapeType_(shapeType) {}
	operator Type() const { return (Type)shapeType_; }

	static ShapeType getTypeByName(const QString & key) {
		QMetaObject metaObject = staticMetaObject;
		const int enumIndex = metaObject.indexOfEnumerator("Type");
		QMetaEnum enumator = metaObject.enumerator(enumIndex);
		return (Type)enumator.keyToValue(key.toLatin1());
	}

	static QString getNameOfType(const ShapeType & type) {
		QMetaObject metaObject = staticMetaObject;
		const int enumIndex = metaObject.indexOfEnumerator("Type");
		QMetaEnum enumator = metaObject.enumerator(enumIndex);
		return enumator.valueToKey(type);
	}

private:
	int shapeType_;
};

class ShapeFactory {
public:
	static ShapeFactoryFunction getShapeFactoryForProductName(const QString & shapeFactoryProduct);

	template <typename ShapeType>
	static std::unique_ptr<Shape> create(const QPointF & startPoint, int penWidth,
	                                     int symmetryCount, const QColor & penColor);

private:
	static const std::map<ShapeType, ShapeFactoryFunction> shapeFactoryRegistration_;
};
