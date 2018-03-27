#pragma once

#include <QObject>
#include <QtAndroidExtras>

#include <QDebug>

class ImagePickerAndroid : public QObject, public QAndroidActivityResultReceiver
{
    Q_OBJECT

public:
    ImagePickerAndroid();

    void searchImage();

    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data);

    int getX() const;
    void setX(int value);

signals:
    void imageHomePathChanged(QString);
};

