#pragma once

#include <QImage>

class CppController : public QObject
{
    Q_OBJECT

public:
    CppController();

    Q_INVOKABLE QImage floodFill(int & start, int & stop, const QColor & fillColor, int x, int y, int width, int height) const;
};
