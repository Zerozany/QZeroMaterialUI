#include "ElementStyle.h"

ElementStyle* ElementStyle::create(QQmlEngine*, QJSEngine*)
{
    static ElementStyle* elementStyle{new ElementStyle{}};
    return elementStyle;
}

ElementStyle::ElementStyle(QObject* _parent) : QObject{_parent}
{
}

quint8 ElementStyle::elementMargins() const
{
    return m_elementMargins;
}

void ElementStyle::setElementMargins(quint8 _elementMargins)
{
    if (m_elementMargins == _elementMargins)
    {
        return;
    }
    m_elementMargins = _elementMargins;
    Q_EMIT this->elementMarginsChanged();
}

quint8 ElementStyle::elementRadius() const
{
    return m_elementRadius;
}

void ElementStyle::setElementRadius(quint8 _elementRadius)
{
    if (m_elementRadius == _elementRadius)
    {
        return;
    }
    m_elementRadius = _elementRadius;
    Q_EMIT this->elementRadiusChanged();
}

quint8 ElementStyle::elementSpacing() const
{
    return m_elementSpacing;
}

void ElementStyle::setElementSpacing(quint8 _elementSpacing)
{
    if (m_elementSpacing == _elementSpacing)
    {
        return;
    }
    m_elementSpacing = _elementSpacing;
    Q_EMIT this->elementSpacingChanged();
}

quint8 ElementStyle::elementPadding() const
{
    return m_elementPadding;
}

void ElementStyle::setElementPadding(quint8 _elementPadding)
{
    if (m_elementPadding == _elementPadding)
    {
        return;
    }
    m_elementPadding = _elementPadding;
    Q_EMIT this->elementPaddingChanged();
}
