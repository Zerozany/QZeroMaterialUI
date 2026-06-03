_Pragma("once");
#include <QObject>
#include <QtQml>

#if defined(Q_OS_WINDOWS) && defined(_MSC_VER)
    #ifdef QZeroMaterialUI
        #define QZERO_API Q_DECL_EXPORT
    #else
        #define QZERO_API Q_DECL_IMPORT
    #endif
#elif defined(__GNUC__) || defined(__clang__)
    #define QZERO_API __attribute__((visibility("default")))
#else
    #define QZERO_API
#endif

class QZERO_API ScreenShotUtils : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
public:
    enum class ImageFormat
    {
        PNG,
        JPG,
        JPEG
    };
    Q_ENUM(ImageFormat)

    Q_PROPERTY(quint8 delay READ delay WRITE setDelay NOTIFY delayChanged);
    Q_PROPERTY(quint8 burstshotCount READ burstshotCount WRITE setBurstshotCount NOTIFY burstshotCountChanged);
    Q_PROPERTY(ImageFormat imageFormat READ imageFormat WRITE setImageFormat NOTIFY imageFormatChanged);

public:
    static ScreenShotUtils* create(QQmlEngine*, QJSEngine*);

    ~ScreenShotUtils() noexcept = default;

    Q_DISABLE_COPY_MOVE(ScreenShotUtils)

public:
    quint8 delay() const;
    void   setDelay(quint8 _delay);

    quint8 burstshotCount() const;
    void   setBurstshotCount(quint8 _burstshotCount);

    ScreenShotUtils::ImageFormat imageFormat() const;
    void                         setImageFormat(const ScreenShotUtils::ImageFormat& _imageFormat);

public:
    Q_INVOKABLE void screenshot(const QString& _savePathDir);

    Q_INVOKABLE void screenshot(quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePathDir);

    Q_INVOKABLE void screenshot(const QRect& _rect, const QString& _savePathDir);

    Q_INVOKABLE void screenshotItem(QObject* _quickItem, const QString& _savePathDir);

    Q_INVOKABLE void screenshotItem(QObject* _quickItem, quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePathDir);

    Q_INVOKABLE void screenshotItem(QObject* _quickItem, const QRect& _rect, const QString& _savePathDir);

protected:
    explicit(true) ScreenShotUtils(QObject* _parent = nullptr);

Q_SIGNALS:
    void delayChanged();

    void burstshotCountChanged();

    void imageFormatChanged();

private:
    quint8      m_delay{};
    quint8      m_burstshotCount{};
    ImageFormat m_imageFormat{ImageFormat::PNG};
};
