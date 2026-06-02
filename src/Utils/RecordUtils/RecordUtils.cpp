#include "RecordUtils.h"
#include <QQuickWindow>
#include <QGuiApplication>

RecordUtils* RecordUtils::create(QQmlEngine*, QJSEngine*)
{
    static RecordUtils* recordUtils{new RecordUtils{}};
    return recordUtils;
}

RecordUtils::RecordUtils(QObject* _parent) : QObject{_parent}
{
}
