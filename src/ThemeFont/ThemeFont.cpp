#include "ThemeFont.h"

ThemeFont* ThemeFont::create(QQmlEngine*, QJSEngine*)
{
    static ThemeFont themeFont{};
    return &themeFont;
}

ThemeFont::ThemeFont(QObject* _parent) : QObject{_parent}
{
    this->setFontFamily(ThemeFont::fontFamilys.value("zh_CN").toString());
    this->setFontSize(ThemeFont::fontSizeType.value("L").toInt());
}

Q_INVOKABLE quint8 ThemeFont::fontSize() const
{
    return m_fontSize;
}

Q_INVOKABLE void ThemeFont::setFontSize(const quint8& _fontSize)
{
    if (m_fontSize == _fontSize)
    {
        return;
    }
    m_fontSize = _fontSize;
    Q_EMIT this->fontSizeChanged();
}

Q_INVOKABLE QString ThemeFont::fontFamily() const
{
    return m_fontFamily;
}

Q_INVOKABLE void ThemeFont::setFontFamily(const QString& _fontFamily)
{
    if (m_fontFamily == _fontFamily)
    {
        return;
    }
    m_fontFamily = _fontFamily;
    Q_EMIT this->fontFamilyChanged();
}
