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

class QQmlEngine;
class QJSEngine;

class QZERO_API ElementStyle : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
    Q_PROPERTY(quint8 elementMargins READ elementMargins WRITE setElementMargins NOTIFY elementMarginsChanged);
    Q_PROPERTY(quint8 elementRadius READ elementRadius WRITE setElementRadius NOTIFY elementRadiusChanged);
    Q_PROPERTY(quint8 elementSpacing READ elementSpacing WRITE setElementSpacing NOTIFY elementSpacingChanged);

public:
    static ElementStyle* create(QQmlEngine*, QJSEngine*);
    ~ElementStyle() noexcept = default;

    Q_INVOKABLE quint8 elementMargins() const;
    Q_INVOKABLE void   setElementMargins(quint8 _elementMargins);

    Q_INVOKABLE quint8 elementRadius() const;
    Q_INVOKABLE void   setElementRadius(quint8 _elementRadius);

    Q_INVOKABLE quint8 elementSpacing() const;
    Q_INVOKABLE void   setElementSpacing(quint8 _elementSpacing);

private:
    explicit(true) ElementStyle(QObject* _parent = nullptr);

Q_SIGNALS:

    void elementMarginsChanged();

    void elementRadiusChanged();

    void elementSpacingChanged();

private:
    quint8 m_elementMargins{5};
    quint8 m_elementRadius{5};
    quint8 m_elementSpacing{5};
};
