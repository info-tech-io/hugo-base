#!/bin/sh
set -e

echo "🎯 Testing Quiz Engine integration..."

# Проверка копирования Quiz Engine файлов
test -f public/quiz/src/quiz-engine/quiz-engine.mjs || { echo "❌ Quiz Engine JS not copied"; exit 1; }

# Проверка примеров квизов
test -f public/quiz/quiz-examples/sc-base.json || { echo "❌ Single choice examples not copied"; exit 1; }
test -f public/quiz/quiz-examples/mc-base.json || { echo "❌ Multiple choice examples not copied"; exit 1; }
test -f public/quiz/quiz-examples/if-base.json || { echo "❌ Input field examples not copied"; exit 1; }

# Подсчет количества примеров квизов
QUIZ_COUNT=$(find public/quiz/quiz-examples/ -name "*.json" | wc -l)
test "$QUIZ_COUNT" -eq 11 || { echo "❌ Expected 11 quiz examples, found $QUIZ_COUNT"; exit 1; }

# Проверка интеграции Quiz Engine в HTML
grep -q "quiz-engine.mjs" public/theme_04/проверочный-тест/index.html || { echo "❌ Quiz Engine not loaded in test page"; exit 1; }

# Проверка количества quiz контейнеров
QUIZ_CONTAINERS=$(grep -c "quiz-container" public/theme_04/проверочный-тест/index.html)
test "$QUIZ_CONTAINERS" -eq 10 || { echo "❌ Expected 10 quiz containers, found $QUIZ_CONTAINERS"; exit 1; }

# Проверка правильных путей к примерам
grep -q "/quiz/quiz-examples/sc-base.json" public/theme_04/проверочный-тест/index.html || { echo "❌ SC base quiz path incorrect"; exit 1; }
grep -q "/quiz/quiz-examples/mc-base.json" public/theme_04/проверочный-тест/index.html || { echo "❌ MC base quiz path incorrect"; exit 1; }
grep -q "/quiz/quiz-examples/if-base.json" public/theme_04/проверочный-тест/index.html || { echo "❌ IF base quiz path incorrect"; exit 1; }

echo "✅ Quiz Engine integration is correct ($QUIZ_COUNT examples, $QUIZ_CONTAINERS containers)"