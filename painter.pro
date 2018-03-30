QT += quick

android {
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

DEFINES += QT_DEPRECATED_WARNINGS

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

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += DESTDIR
QML_IMPORT_TRACE = 1

# Additional import path used to resolve QML modules just for Qt Quick Designer
#QML_DESIGNER_IMPORT_PATH =

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

DISTFILES += \
    note.txt
