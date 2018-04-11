TEMPLATE = lib
CONFIG += plugin
QT += qml quick

TARGET = symmetriccanvasplugin

HEADERS += \
    shape.h \
    commandhistorycontroller/command.h \
    commandhistorycontroller/commandgroup.h \
    commandhistorycontroller/history.h \
    commandhistorycontroller/paintercommands.h \
    imagemanipulation/floodfill.h \
    symmetriccanvas.h \
    symmetriccanvasplugin.h

SOURCES += \
    shape.cpp \
    commandhistorycontroller/commandgroup.cpp \
    commandhistorycontroller/history.cpp \
    imagemanipulation/floodfill.cpp \
    symmetriccanvas.cpp \
    symmetriccanvasplugin.cpp

CONFIG(debug, debug|release) {
    DESTDIR =     ../bin/debug/SymmetricCanvas
    OBJECTS_DIR = ../bin/debug/SymmetricCanvas/.obj
    MOC_DIR =     ../bin/debug/SymmetricCanvas/.moc
    RCC_DIR =     ../bin/debug/SymmetricCanvas/.rcc
    UI_DIR =      ../bin/debug/SymmetricCanvas/.ui
} else {
    DESTDIR =     ../bin/release/SymmetricCanvas
    OBJECTS_DIR = ../bin/release/SymmetricCanvas/.obj
    MOC_DIR =     ../bin/release/SymmetricCanvas/.moc
    RCC_DIR =     ../bin/release/SymmetricCanvas/.rcc
    UI_DIR =      ../bin/release/SymmetricCanvas/.ui
}

target.path = $$DESTDIR
qmldir.files = $$PWD/qmldir
qmldir.path = $$DESTDIR
INSTALLS += target qmldir

CONFIG += install_ok

OTHER_FILES += qmldir

# Copy the qmldir file to the same folder as the plugin binary
cpqmldir.files = qmldir
cpqmldir.path = $$DESTDIR
COPIES += cpqmldir
