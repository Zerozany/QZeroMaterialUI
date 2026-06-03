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
    static auto screenshotPrivate{[]<typename T>(quint8 _delay, const ScreenShotUtils* _screenShotUtils, const QString& _savePathDir, T&& _arg) noexcept -> void {
        QPointer<QQuickWindow> window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
        QTimer::singleShot(_delay, _screenShotUtils, [=] {
            QImage shotImage{window->grabWindow()};
            if constexpr (std::is_same_v<std::decay_t<T>, QRect>)
            {
                shotImage = shotImage.copy(_arg);
            }
            if (!QDir{_savePathDir}.mkpath("."))
            {
                return;
            }
            shotImage.save(QDir{_savePathDir}.filePath(QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss_zzz") + ".png"));
        });
    }};

    static auto screenshotItemPrivate{[]<typename T>(quint8 _delay, const ScreenShotUtils* _screenShotUtils, QObject* _quickItem, const QString& _savePathDir, T&& _arg) noexcept -> void {
        QSharedPointer<QQuickItemGrabResult> result{qobject_cast<QQuickItem*>(_quickItem)->grabToImage()};
        QObject::connect(result.data(), &QQuickItemGrabResult::ready, [=] {
            QTimer::singleShot(_delay, _screenShotUtils, [=] {
                QImage shotImage{result.data()->image()};
                if constexpr (std::is_same_v<std::decay_t<T>, QRect>)
                {
                    shotImage = shotImage.copy(_arg);
                }
                if (!QDir{_savePathDir}.mkpath("."))
                {
                    return;
                }
                shotImage.save(QDir{_savePathDir}.filePath(QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss_zzz") + ".png"));
            });
        });
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

void ScreenShotUtils::screenshot(const QString& _savePathDir)
{
    Private::screenshotPrivate.operator()<std::monostate>(this->m_delay, this, _savePathDir, std::monostate{});
}

void ScreenShotUtils::screenshot(quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePathDir)
{
    if (_width <= 0 || _height <= 0)
    {
        return;
    }
    Private::screenshotPrivate.operator()<QRect>(this->m_delay, this, _savePathDir, QRect{_x, _y, _width, _height});
}

void ScreenShotUtils::screenshot(const QRect& _rect, const QString& _savePathDir)
{
    if (_rect.width() <= 0 || _rect.height() <= 0)
    {
        return;
    }
    Private::screenshotPrivate.operator()<const QRect&>(this->m_delay, this, _savePathDir, _rect);
}

void ScreenShotUtils::screenshotItem(QObject* _quickItem, const QString& _savePathDir)
{
    if (!_quickItem)
    {
        return;
    }
    Private::screenshotItemPrivate.operator()<std::monostate>(this->m_delay, this, _quickItem, _savePathDir, std::monostate{});
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
    Private::screenshotItemPrivate.operator()<QRect>(this->m_delay, this, _quickItem, _savePathDir, QRect{_x, _y, _width, _height});
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
    Private::screenshotItemPrivate.operator()<const QRect&>(this->m_delay, this, _quickItem, _savePathDir, _rect);
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

quint8 ScreenShotUtils::burstshotCount() const
{
    return m_burstshotCount;
}

void ScreenShotUtils::setBurstshotCount(quint8 _burstshotCount)
{
    if (m_burstshotCount == _burstshotCount)
    {
        return;
    }
    m_burstshotCount = _burstshotCount;
    Q_EMIT this->burstshotCountChanged();
}
