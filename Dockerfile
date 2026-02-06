# Stage 1: Build da aplicação Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS build

WORKDIR /app

# Copia os arquivos de dependências primeiro (melhor cache)
COPY pubspec.yaml pubspec.lock* ./

# Instala as dependências
RUN flutter pub get

# Copia o restante do projeto
COPY . .

# Build da versão web em modo release
RUN flutter build web --release

# Stage 2: Servir com Nginx
FROM nginx:alpine

# Remove a config padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia config customizada do Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Configuração do Nginx para SPA (Single Page Application)
RUN echo 'server { \
    listen 80; \
    server_name _; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
    \
    # Cache de assets estáticos \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ { \
        expires 1y; \
        add_header Cache-Control "public, immutable"; \
    } \
    \
    # Sem cache para index.html \
    location = /index.html { \
        add_header Cache-Control "no-cache, no-store, must-revalidate"; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
