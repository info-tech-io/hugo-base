#!/bin/sh
set -e

echo "📁 Testing project structure..."

# Проверка основных файлов
test -f hugo.toml || { echo "❌ hugo.toml not found"; exit 1; }
test -f Dockerfile || { echo "❌ Dockerfile not found"; exit 1; }
test -f .gitmodules || { echo "❌ .gitmodules not found"; exit 1; }

# Проверка директорий
test -d themes/compose || { echo "❌ themes/compose not found"; exit 1; }
test -d static/quiz || { echo "❌ static/quiz not found"; exit 1; }
test -d content || { echo "❌ content directory not found"; exit 1; }

# Проверка структуры контента
test -f content/_index.md || { echo "❌ content/_index.md not found"; exit 1; }
test -d content/intro || { echo "❌ content/intro not found"; exit 1; }
test -d content/theme_01 || { echo "❌ content/theme_01 not found"; exit 1; }
test -d content/theme_02 || { echo "❌ content/theme_02 not found"; exit 1; }
test -d content/theme_03 || { echo "❌ content/theme_03 not found"; exit 1; }
test -d content/theme_04 || { echo "❌ content/theme_04 not found"; exit 1; }
test -d content/outro || { echo "❌ content/outro not found"; exit 1; }

# Проверка Quiz Engine файлов
test -f static/quiz/src/quiz-engine/quiz-engine.mjs || { echo "❌ Quiz Engine not found"; exit 1; }
test -d static/quiz/quiz-examples || { echo "❌ Quiz examples directory not found"; exit 1; }

echo "✅ Project structure is valid"