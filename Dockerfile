# Multi-stage Docker build для hugo-base с встроенными тестами интеграции
# Используем официальный образ Hugo
FROM ghcr.io/gohugoio/hugo:v0.148.2 AS builder

# Установка зависимостей для тестирования (git нужен для submodules)
USER root
RUN apk add --no-cache \
    git \
    nodejs \
    npm \
    curl \
    jq \
    grep

# Создание рабочей директории
WORKDIR /src

# Копирование исходного кода
COPY . .

# Инициализация submodules (если они еще не инициализированы)
RUN git submodule update --init --recursive || echo "Submodules already initialized"

# Копируем и запускаем скрипты тестирования
COPY scripts/ /src/scripts/
RUN chmod +x /src/scripts/*.sh && \
    # Адаптированные тесты для Docker (без git проверок)
    ./scripts/test-hugo-config.sh && \
    ./scripts/test-hugo-build.sh && \
    ./scripts/test-quiz-engine.sh && \
    ./scripts/test-navigation.sh && \
    echo "✅ Docker integration tests passed"

# Production stage - nginx
FROM nginx:alpine AS production

# Копирование сгенерированного сайта
COPY --from=builder /src/public /usr/share/nginx/html

# Кастомная конфигурация nginx
RUN cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;
    
    # Основные настройки
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Quiz Engine файлы с правильными MIME типами
    location /quiz/ {
        location ~* \.(mjs|js)$ {
            add_header Content-Type application/javascript;
            add_header Access-Control-Allow-Origin *;
        }
        location ~* \.(json)$ {
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
        }
    }
    
    # Кэширование статических файлов
    location ~* \.(css|js|mjs|json|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    
    # Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
}
EOF

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Метаданные
LABEL maintainer="InfoTech.io <info@infotecha.ru>"
LABEL version="1.0.0"
LABEL description="Hugo-based educational module template with Quiz Engine integration"
LABEL org.opencontainers.image.title="hugo-base"
LABEL org.opencontainers.image.description="Educational module template for InfoTech.io platform"
LABEL org.opencontainers.image.source="https://github.com/info-tech-io/hugo-base"
LABEL org.opencontainers.image.documentation="https://github.com/info-tech-io/hugo-base/blob/main/README.md"

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
