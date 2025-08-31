#!/bin/sh
set -e

echo "🏗️ Testing Hugo site build..."

# Сборка сайта
hugo --minify || { echo "❌ Hugo build failed"; exit 1; }

# Проверка генерации основных страниц
test -f public/index.html || { echo "❌ Homepage not generated"; exit 1; }
test -f public/intro/index.html || { echo "❌ Intro page not generated"; exit 1; }
test -f public/theme_01/index.html || { echo "❌ Theme 01 not generated"; exit 1; }
test -f public/theme_02/index.html || { echo "❌ Theme 02 not generated"; exit 1; }
test -f public/theme_03/index.html || { echo "❌ Theme 03 not generated"; exit 1; }
test -f public/theme_04/index.html || { echo "❌ Theme 04 index not generated"; exit 1; }
test -f public/theme_04/проверочный-тест/index.html || { echo "❌ Test page not generated"; exit 1; }
test -f public/outro/index.html || { echo "❌ Outro page not generated"; exit 1; }

# Проверка копирования статических файлов
test -d public/quiz || { echo "❌ Quiz directory not copied to public"; exit 1; }

echo "✅ Hugo site built successfully"