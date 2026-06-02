#include "ScreenShotUtils.h"
#include <QGuiApplication>
#include <QImage>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQuickItemGrabResult>
#include <QTimer>
#include <QDateTime>
#include <QDir>

namespace Private
{
    static auto saveImage{[](const QImage& _shootImage, const QString& _savePathDir) noexcept -> void {
        if (!QDir{_savePathDir}.mkpath("."))
        {
            return;
        }
        _shootImage.save(QDir{_savePathDir}.filePath(QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss_zzz") + ".png"));
    }};
}  // namespace Private

ScreenShotUtils* ScreenShotUtils::create(QQmlEngine*, QJSEngine*)
{
    static ScreenShotUtils* screenShotUtils{new ScreenShotUtils{}};
    return screenShotUtils;
}

ScreenShotUtils::ScreenShotUtils(QObject* _parent) : QObject{_parent}
{
}

quint8 ScreenShotUtils::delay() const
{
    return m_delay;
}

void ScreenShotUtils::setDelay(quint8 _delay)
{
    if (m_delay == _delay)
    {
        return;
    }
    m_delay = _delay;
    Q_EMIT this->delayChanged();
}

void ScreenShotUtils::screenshot(const QString& _savePathDir)
{
    QPointer<QQuickWindow> window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
    QTimer::singleShot(this->m_delay, this, [_savePathDir, window] {
        QImage shootImage{window->grabWindow()};
        Private::saveImage(shootImage, _savePathDir);
    });
}

void ScreenShotUtils::screenshot(quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePathDir)
{
    if (_width <= 0 || _height <= 0)
    {
        return;
    }
    QPointer<QQuickWindow> window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
    QTimer::singleShot(this->m_delay, this, [_x, _y, _width, _height, _savePathDir, window] {
        QImage shootImage{window->grabWindow()};
        shootImage = shootImage.copy(QRect{_x, _y, _width, _height});
        Private::saveImage(shootImage, _savePathDir);
    });
}

void ScreenShotUtils::screenshot(const QRect& _rect, const QString& _savePathDir)
{
    if (_rect.width() <= 0 || _rect.height() <= 0)
    {
        return;
    }
    QPointer<QQuickWindow> window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
    QTimer::singleShot(this->m_delay, this, [_rect, _savePathDir, window] {
        QImage shootImage{window->grabWindow()};
        shootImage = shootImage.copy(_rect);
        Private::saveImage(shootImage, _savePathDir);
    });
}

void ScreenShotUtils::screenshotItem(QObject* _quickItem, const QString& _savePathDir)
{
    if (!_quickItem)
    {
        return;
    }
    // TODO 1 内部lambda函数作为槽函数
    // TODO 2 添加延时截图
    QSharedPointer<QQuickItemGrabResult> result{qobject_cast<QQuickItem*>(_quickItem)->grabToImage()};
    QObject::connect(result.data(), &QQuickItemGrabResult::ready, [result, _savePathDir] {
        QImage shootImage{result.data()->image()};
        Private::saveImage(shootImage, _savePathDir);
    });
}

void ScreenShotUtils::screenshotItem(QObject* _quickItem, const QRect& _rect, const QString& _savePathDir)
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
    QObject::connect(result.data(), &QQuickItemGrabResult::ready, [result, _rect, _savePathDir] {
        QImage shootImage{result.data()->image()};
        shootImage = shootImage.copy(_rect);
        Private::saveImage(shootImage, _savePathDir);
    });
}

void ScreenShotUtils::screenshotItem(QObject* _quickItem, quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePathDir)
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
    QObject::connect(result.data(), &QQuickItemGrabResult::ready, [result, _x, _y, _width, _height, _savePathDir] {
        QImage shootImage{result.data()->image()};
        shootImage = shootImage.copy(QRect{_x, _y, _width, _height});
        Private::saveImage(shootImage, _savePathDir);
    });
}
