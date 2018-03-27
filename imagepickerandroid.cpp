#include "imagepickerandroid.h"

ImagePickerAndroid::ImagePickerAndroid()
{

}

void ImagePickerAndroid::searchImage()
{
    QAndroidJniObject ACTION_PICK = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
    QAndroidJniObject intent("android/content/Intent");
    if (ACTION_PICK.isValid() && intent.isValid())
    {
        intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", ACTION_PICK.object<jstring>());
        intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
        QtAndroid::startActivity(intent.object<jobject>(), 1, this);
        qDebug() << "ok";
    }
    else
    {
        qDebug() << "error";
    }
}

void ImagePickerAndroid::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data)
{
    jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
    if (receiverRequestCode == 1 && resultCode == RESULT_OK) {
        QString imagePath = data.callObjectMethod("getData", "()Landroid/net/Uri;").callObjectMethod("getPath", "()Ljava/lang/String;").toString();
        emit imageHomePathChanged(imagePath);
        qDebug() << imagePath;
    }
    else
    {
        qDebug() << "error";
    }
}
