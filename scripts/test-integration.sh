#!/bin/sh
set -e

echo "🔧 Starting integration tests for hugo-base..."

# Запуск всех тестовых модулей
echo "📋 Running all integration test modules..."

# 1. Тест структуры проекта
./scripts/test-project-structure.sh

# 2. Тест конфигурации Hugo
./scripts/test-hugo-config.sh

# 3. Тест сборки Hugo
./scripts/test-hugo-build.sh

# 4. Тест Quiz Engine
./scripts/test-quiz-engine.sh

# 5. Тест навигации
./scripts/test-navigation.sh

echo "🎉 All integration tests passed successfully!"