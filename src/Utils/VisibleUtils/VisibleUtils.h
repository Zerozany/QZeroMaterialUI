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

class QZERO_API VisibleUtils : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
public:
    static VisibleUtils* create(QQmlEngine*, QJSEngine*);

    ~VisibleUtils() noexcept = default;

    Q_DISABLE_COPY_MOVE(VisibleUtils)

public:
    Q_INVOKABLE void screenshot(const QString& _savePath);

    Q_INVOKABLE void screenshot(quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePath);

    Q_INVOKABLE void screenshot(const QRect& _rect, const QString& _savePath);

    Q_INVOKABLE void screenshotItem(QObject* _quickItem, const QString& _savePath);

    Q_INVOKABLE void screenshotItem(QObject* _quickItem, const QRect& _rect, const QString& _savePath);

    Q_INVOKABLE void screenshotItem(QObject* _quickItem, quint16 _x, quint16 _y, quint16 _width, quint16 _height, const QString& _savePath);

protected:
    explicit(true) VisibleUtils(QObject* _parent = nullptr);
};
