#!/bin/sh
set -e

echo "🧭 Testing site navigation..."

# Проверка навигации между разделами
grep -q "/theme_01/" public/intro/index.html || { echo "❌ Navigation from intro to theme_01 broken"; exit 1; }
grep -q "/theme_02/" public/theme_01/index.html || { echo "❌ Navigation from theme_01 to theme_02 broken"; exit 1; }
grep -q "/theme_03/" public/theme_02/index.html || { echo "❌ Navigation from theme_02 to theme_03 broken"; exit 1; }
grep -q "/theme_04/" public/theme_03/index.html || { echo "❌ Navigation from theme_03 to theme_04 broken"; exit 1; }
grep -q "/outro/" public/theme_04/проверочный-тест/index.html || { echo "❌ Navigation from theme_04 to outro broken"; exit 1; }

# Проверка обратной навигации
grep -q "/theme_03/" public/theme_04/index.html || { echo "❌ Back navigation from theme_04 to theme_03 broken"; exit 1; }
grep -q "/theme_04/" public/outro/index.html || { echo "❌ Back navigation from outro to theme_04 broken"; exit 1; }

# Проверка навигации внутри theme_04
grep -q "проверочный-тест" public/theme_04/index.html || { echo "❌ Navigation to test page broken"; exit 1; }
grep -q "/theme_04/" public/theme_04/проверочный-тест/index.html || { echo "❌ Navigation back to theme_04 broken"; exit 1; }

# Проверка основных элементов навигации (кнопки)
grep -q "button" public/intro/index.html || { echo "❌ Navigation buttons not found in intro"; exit 1; }
grep -q "button" public/theme_04/проверочный-тест/index.html || { echo "❌ Navigation buttons not found in test page"; exit 1; }

echo "✅ Navigation links are correct"