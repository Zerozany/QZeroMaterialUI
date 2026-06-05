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
    static constexpr const char* ImageNameFormat{"yyyyMMdd_HHmmss_zzz"};

    static auto imageFormatToString(const ScreenShotUtils::ImageFormat& _imageFormat) noexcept -> const QString
    {
        switch (_imageFormat)
        {
            case ScreenShotUtils::ImageFormat::PNG:
            {
                return ".png";
            }
            case ScreenShotUtils::ImageFormat::JPG:
            {
                return ".jpg";
            }
            case ScreenShotUtils::ImageFormat::JPEG:
            {
                return ".jpeg";
            }
            default:
            {
                std::unreachable();
            }
        }
    }

    static auto screenshotPrivate{[]<typename T>(const ScreenShotUtils* _screenShotUtils, const QString& _savePathDir, T&& _arg) noexcept -> void {
        QPointer<QQuickWindow> window{qobject_cast<QQuickWindow*>(QGuiApplication::topLevelWindows().first())};
        QTimer::singleShot(_screenShotUtils->delay(), _screenShotUtils, [=] {
            for (int i{}; ++i <= _screenShotUtils->burstshot();)
            {
                QImage shotImage{window->grabWindow()};
                if constexpr (std::is_same_v<std::decay_t<T>, QRect>)
                {
                    shotImage = shotImage.copy(_arg);
                }
                if (!QDir{_savePathDir}.mkpath("."))
                {
                    return;
                }
                shotImage.save(QDir{_savePathDir}.filePath(QDateTime::currentDateTime().toString(Private::ImageNameFormat) + Private::imageFormatToString(_screenShotUtils->imageFormat())));
            }
        });
    }};

    static auto screenshotItemPrivate{[]<typename T>(const ScreenShotUtils* _screenShotUtils, QObject* _quickItem, const QString& _savePathDir, T&& _arg) noexcept -> void {
        QSharedPointer<QQuickItemGrabResult> result{qobject_cast<QQuickItem*>(_quickItem)->grabToImage()};
        QObject::connect(result.data(), &QQuickItemGrabResult::ready, [=] {
            QTimer::singleShot(_screenShotUtils->delay(), _screenShotUtils, [=] {
                for (int i{}; ++i <= _screenShotUtils->burstshot();)
                {
                    QImage shotImage{result.data()->image()};
                    if constexpr (std::is_same_v<std::decay_t<T>, QRect>)
                    {
                        shotImage = shotImage.copy(_arg);
                    }
                    if (!QDir{_savePathDir}.mkpath("."))
                    {
                        return;
                    }
                    shotImage.save(QDir{_savePathDir}.filePath(QDateTime::currentDateTime().toString(Private::ImageNameFormat) + Private::imageFormatToString(_screenShotUtils->imageFormat())));
                }
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
    Private::screenshotPrivate.operator()<std::monostate>(this, _savePathDir, std::monostate{});
}

void ScreenShotUtils::screenshot(quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePathDir)
{
    if (_width <= 0 || _height <= 0)
    {
        return;
    }
    Private::screenshotPrivate.operator()<QRect>(this, _savePathDir, QRect{_x, _y, _width, _height});
}

void ScreenShotUtils::screenshot(const QRect& _rect, const QString& _savePathDir)
{
    if (_rect.width() <= 0 || _rect.height() <= 0)
    {
        return;
    }
    Private::screenshotPrivate.operator()<const QRect&>(this, _savePathDir, _rect);
}

void ScreenShotUtils::screenshotItem(QObject* _quickItem, const QString& _savePathDir)
{
    if (!_quickItem)
    {
        return;
    }
    Private::screenshotItemPrivate.operator()<std::monostate>(this, _quickItem, _savePathDir, std::monostate{});
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
    Private::screenshotItemPrivate.operator()<QRect>(this, _quickItem, _savePathDir, QRect{_x, _y, _width, _height});
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
    Private::screenshotItemPrivate.operator()<const QRect&>(this, _quickItem, _savePathDir, _rect);
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

quint8 ScreenShotUtils::burstshot() const
{
    return m_burstshot;
}

void ScreenShotUtils::setBurstshot(quint8 _burstshot)
{
    if (m_burstshot == _burstshot)
    {
        return;
    }
    m_burstshot = _burstshot;
    Q_EMIT this->burstshotChanged();
}

ScreenShotUtils::ImageFormat ScreenShotUtils::imageFormat() const
{
    return m_imageFormat;
}

void ScreenShotUtils::setImageFormat(const ScreenShotUtils::ImageFormat& _imageFormat)
{
    if (m_imageFormat == _imageFormat)
    {
        return;
    }
    m_imageFormat = _imageFormat;
    Q_EMIT this->imageFormatChanged();
}
