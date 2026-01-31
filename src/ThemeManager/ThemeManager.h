_Pragma("once");
#include <QObject>
#include <QStandardPaths>
#include <QDir>
#include <QtQml>
#include <QVariantMap>

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

static constexpr const char* THEMESDIRNAME{"Themes"};
static constexpr const char* THEMESCONFIGNAME{"ThemeConfig.ini"};

namespace ThemeColorName
{
    static constexpr const char* BackgroundColor{"BackgroundColor"};
    static constexpr const char* TextColor{"TextColor"};
    static constexpr const char* ButtonColor{"ButtonColor"};
    static constexpr const char* ElementColor{"ElementColor"};
    static constexpr const char* LabelColor{"LabelColor"};
};  // namespace ThemeColorName

class QZERO_API ThemeManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
    Q_PROPERTY(QString currentThemeName READ currentThemeName WRITE setCurrentThemeName NOTIFY currentThemeNameChanged);
    Q_PROPERTY(QVariantMap currentTheme READ currentTheme WRITE setCurrentTheme NOTIFY currentThemeChanged);

public:
    static ThemeManager* create(QQmlEngine*, QJSEngine*);

    ~ThemeManager() noexcept = default;

    Q_INVOKABLE QVariantMap currentTheme() const;
    Q_INVOKABLE void        setCurrentTheme(const QVariantMap& _currentTheme);

    Q_INVOKABLE QString currentThemeName() const;
    Q_INVOKABLE void    setCurrentThemeName(const QString& _currentThemeName);

public:
    Q_INVOKABLE QStringList getThemesList();

private:
    explicit(true) ThemeManager(QObject* _parent = nullptr);

    auto init() noexcept -> void;

    auto initThemeConfig() noexcept -> void;

    auto setLightTheme() noexcept -> void;

    auto setDarkTheme() noexcept -> void;

    auto connectSignal2Slot() noexcept -> void;

Q_SIGNALS:
    void currentThemeNameChanged();

    void currentThemeChanged();

private Q_SLOTS:
    void onCurrentThemeNameChanged();

private:
#if defined(Q_OS_WINDOWS)
    QDir    m_themesDir{QDir(qApp->applicationDirPath()).filePath(THEMESDIRNAME)};
    QString m_themeConfigDir{QDir(qApp->applicationDirPath()).filePath(THEMESCONFIGNAME)};
#elif defined(Q_OS_ANDROID)
    QDir    m_themesDir{QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)).filePath(THEMESDIRNAME)};
    QString m_themeConfigDir{QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)).filePath(THEMESCONFIGNAME)};
#endif
    QVariantMap m_currentTheme{};
    QString     m_currentThemeName{};

private:
    QVariantMap m_lightTheme{
        {ThemeColorName::BackgroundColor, "#f0efee"},
        {ThemeColorName::TextColor, "#0e0d0d"},
        {ThemeColorName::ButtonColor, "#FFFFFF"},
        {ThemeColorName::ElementColor, "#FFFFFF"},
        {ThemeColorName::LabelColor, "transparent"},
    };

    QVariantMap m_darkTheme{
        {ThemeColorName::BackgroundColor, "#131212"},
        {ThemeColorName::TextColor, "#FFFFFF"},
        {ThemeColorName::ButtonColor, "#FFFFFF"},
        {ThemeColorName::ElementColor, "rgb(100, 94, 94)"},
        {ThemeColorName::LabelColor, "transparent"},
    };
};
