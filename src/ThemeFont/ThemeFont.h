_Pragma("once");
#include <QObject>
#include <QtQml>

#if defined(Q_OS_WINDOWS) && defined(_MSC_VER)
    #ifdef QZeroZanyUI
        #define QZERO_API Q_DECL_EXPORT
    #else
        #define QZERO_API Q_DECL_IMPORT
    #endif
#else
    #define QZERO_API
#endif

class QJSEngine;
class QQmlEngine;

class QZERO_API ThemeFont : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
    Q_PROPERTY(quint8 fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged);
    Q_PROPERTY(QString fontFamily READ fontFamily WRITE setFontFamily NOTIFY fontFamilyChanged);

public:
    inline static QVariantMap fontFamilys{
        {"zh_CW", "微软雅黑"},
        {"en_US", "Arial"},
    };

    inline static QVariantMap fontSizeType{
        {"XXL", 16},
        {"XL", 14},
        {"L", 12},
        {"S", 10},
        {"M", 8},
    };

public:
    static ThemeFont* create(QQmlEngine*, QJSEngine*);
    ~ThemeFont() noexcept = default;

    Q_INVOKABLE quint8 fontSize() const;
    Q_INVOKABLE void   setFontSize(const quint8& _fontSize);

    Q_INVOKABLE QString fontFamily() const;
    Q_INVOKABLE void    setFontFamily(const QString& _fontFamily);

private:
    explicit(true) ThemeFont(QObject* _parent = nullptr);

Q_SIGNALS:

    void fontSizeChanged();

    void fontFamilyChanged();

private:
    QString m_fontFamily{};
    quint8  m_fontSize{};
};
