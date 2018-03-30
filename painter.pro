QT += quick

android{
QT += androidextras
}

CONFIG += c++11

CONFIG(debug, debug|release) {
    DESTDIR = bin/debug
    OBJECTS_DIR = bin/debug/.obj
    MOC_DIR = bin/debug/.moc
    RCC_DIR = bin/debug/.rcc
    UI_DIR = bin/debug/.ui
} else {
    DESTDIR = bin/release
    OBJECTS_DIR = bin/release/.obj
    MOC_DIR = bin/release/.moc
    RCC_DIR = bin/release/.rcc
    UI_DIR = bin/release/.ui
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


HEADERS += \
    floodfill.h \
    cppcontroller.h \
    commandhistorycontroller/command.h \
    commandhistorycontroller/commandgroup.h \
    commandhistorycontroller/paintercommands.h \
    commandhistorycontroller/history.h

SOURCES += \
    main.cpp \
    floodfill.cpp \
    cppcontroller.cpp \
    commandhistorycontroller/commandgroup.cpp \
    commandhistorycontroller/history.cpp

RESOURCES += qml.qrc

# QT_IM_MODULE=qtvirtualkeyboard

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

android{
HEADERS += \
    androidfiledialog.h \
    imagepickerandroid.h

SOURCES += \
    androidfiledialog.cpp \
    imagepickerandroid.cpp

DISTFILES += \
    android-sources/AndroidManifest.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
}

HEADERS += \
    floodfill.h \
    cppcontroller.h

DISTFILES += \
    note.txt
