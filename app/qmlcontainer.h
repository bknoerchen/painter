#pragma once

#include <QObject>
#include <QVariant>

class QmlContainer : public QObject {
    Q_OBJECT

    Q_PROPERTY(QVariant container READ getContainer WRITE setContainer)

public:
    QmlContainer() {}

    QVariant getContainer() const
    {
        return container_;
    }

    void setContainer(const QVariant & container)
    {
        container_ = container;
    }

private:
    QVariant container_;
};
