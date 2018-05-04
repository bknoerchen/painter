#include "shape.h"

#include <QPen>

Shape::Shape(int penWidth, int symmetryCount, const ShapeMirrorType & mirrorType, const QColor & penColor)
    : penWidth_{penWidth}
    , symmetryCount_{symmetryCount}
    , mirrorType_{mirrorType}
    , penColor_{penColor}
{
}

Shape::~Shape()
{
}

void Shape::draw(QPainter & painter)
{
	painter.save();

	painter.setPen(QPen(penColor_, penWidth_, Qt::SolidLine,
	                    Qt::RoundCap, Qt::SvgMiterJoin));
	painter.setRenderHints(QPainter::Antialiasing, true);

	for (int i = 0; i < symmetryCount_; i++) {
		painter.save();
		painter.translate(painter.window().width() / 2, painter.window().height() / 2);
		painter.rotate(i * (float)360 / (float)symmetryCount_);
		painter.translate(-painter.window().width() / 2, -painter.window().height() / 2);
		drawImpl(painter);
		painter.restore();

		if (mirrorType_ != ShapeMirrorType::MirrorOff) {
			painter.save();
			painter.translate(painter.window().width() / 2, painter.window().height() / 2);

			if (mirrorType_ == ShapeMirrorType::MirrorOnX) {
				painter.scale(1.0, -1.0);
			} else if (mirrorType_ == ShapeMirrorType::MirrorOnY) {
				painter.scale(-1.0, 1.0);
			}

			painter.rotate(i * (float)360 / (float)symmetryCount_);
			painter.translate(-painter.window().width() / 2, -painter.window().height() / 2);
			drawImpl(painter);
			painter.restore();
		}
	}
	painter.restore();
}

QRectF Shape::getBoundingRect() const
{
	// Consider pen's width and make sure the outline is included in the
	// returned rectangle.
	const int rad = penWidth_ / 2 + 2;
	return getBoundingRectImpl().adjusted(-rad, -rad, +rad, +rad);
}
