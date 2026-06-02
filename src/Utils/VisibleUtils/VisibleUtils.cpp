#include "VisibleUtils.h"
#include <QGuiApplication>
#include <QImage>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQuickItemGrabResult>

VisibleUtils* VisibleUtils::create(QQmlEngine*, QJSEngine*)
{
    static VisibleUtils* visibleUtils{new VisibleUtils{}};
    return visibleUtils;
}

VisibleUtils::VisibleUtils(QObject* _parent) : QObject{_parent}
{
}

void VisibleUtils::screenshot(const QString& _savePath)
{
    QQuickWindow* window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
    QImage        shotImage{window->grabWindow()};
    shotImage.save(_savePath);
}

void VisibleUtils::screenshot(quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePath)
{
    QQuickWindow* window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
    QImage        shotImage{window->grabWindow()};
    if (_width <= 0 || _height <= 0)
    {
        return;
    }
    shotImage = shotImage.copy(QRect{_x, _y, _width, _height});
    shotImage.save(_savePath);
}

void VisibleUtils::screenshot(const QRect& _rect, const QString& _savePath)
{
    QQuickWindow* window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
    QImage        shotImage{window->grabWindow()};
    if (_rect.width() <= 0 && _rect.height() <= 0)
    {
        return;
    }
    shotImage = shotImage.copy(_rect);
    shotImage.save(_savePath);
}

void VisibleUtils::screenshotItem(QObject* _quickItem, const QString& _savePath)
{
    if (!_quickItem)
    {
        return;
    }
    QSharedPointer<QQuickItemGrabResult> result{qobject_cast<QQuickItem*>(_quickItem)->grabToImage()};
    QObject::connect(result.data(), &QQuickItemGrabResult::ready, [result, _savePath] {
        QImage shotImage{result.data()->image()};
        shotImage.save(_savePath);
    });
}

void VisibleUtils::screenshotItem(QObject* _quickItem, const QRect& _rect, const QString& _savePath)
{
    if (!_quickItem)
    {
        return;
    }
    if (_rect.width() <= 0 || _rect.height() <= 0)
    {
        return;
    }
    QSharedPointer<QQuickItemGrabResult> result{qobject_cast<QQuickItem*>(_quickItem)->grabToImage()};
    QObject::connect(result.data(), &QQuickItemGrabResult::ready, [result, _rect, _savePath] {
        QImage shotImage{result.data()->image()};
        shotImage = shotImage.copy(_rect);
        shotImage.save(_savePath);
    });
}

void VisibleUtils::screenshotItem(QObject* _quickItem, quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePath)
{
    if (!_quickItem)
    {
        return;
    }
    if (_width <= 0 || _height <= 0)
    {
        return;
    }
    QSharedPointer<QQuickItemGrabResult> result{qobject_cast<QQuickItem*>(_quickItem)->grabToImage()};
    QObject::connect(result.data(), &QQuickItemGrabResult::ready, [result, _x, _y, _width, _height, _savePath] {
        QImage shotImage{result.data()->image()};
        shotImage = shotImage.copy(QRect{_x, _y, _width, _height});
        shotImage.save(_savePath);
    });
}
