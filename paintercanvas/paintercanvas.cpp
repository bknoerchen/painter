#include "paintercanvas.h"

#include <QPainter>

PainterCanvas::PainterCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
}

QString PainterCanvas::name() const
{
    return m_name;
}

void PainterCanvas::setName(const QString &name)
{
    m_name = name;
}

QColor PainterCanvas::color() const
{
	return m_color;
}

void PainterCanvas::setColor(const QColor & color)
{
	m_color = color;
}

void PainterCanvas::paint(QPainter * painter)
{
	QPen pen(m_color, 2);
	painter->setPen(pen);
	painter->setRenderHints(QPainter::Antialiasing, true);
	painter->drawPie(boundingRect().adjusted(1, 1, -1, -1), 90 * 16, 290 * 16);
}
