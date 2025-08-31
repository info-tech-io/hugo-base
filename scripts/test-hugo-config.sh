#!/bin/sh
set -e

echo "🔧 Testing Hugo configuration..."

# Проверка версии Hugo
hugo version || { echo "❌ Hugo not available"; exit 1; }

# Проверка конфигурации Hugo
hugo config || { echo "❌ Hugo config is invalid"; exit 1; }

# Проверка наличия theme_04 в docSections
hugo config | grep -q "theme_04" || { echo "❌ theme_04 not found in docSections"; exit 1; }

# Проверка настроек темы
hugo config | grep -q "compose" || { echo "❌ Compose theme not configured"; exit 1; }

# Проверка baseURL
hugo config | grep -q "infotecha.ru" || { echo "❌ infotecha.ru domain not configured"; exit 1; }

echo "✅ Hugo configuration is valid"