# Build stage
FROM node:22-alpine AS builder

WORKDIR /app

# Copiar todos os arquivos do projeto
COPY . .

# Instalar dependências (ignora postinstall que precisa dos arquivos)
RUN npm ci --ignore-scripts

# Rodar quasar prepare manualmente após ter todos os arquivos
RUN npx quasar prepare

# Aceitar variáveis de ambiente de build
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Build da aplicação
RUN npm run build

# Production stage
FROM nginx:alpine AS production

# Copiar configuração customizada do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar arquivos buildados do estágio anterior
COPY --from=builder /app/dist/spa /usr/share/nginx/html

# Expor porta 80
EXPOSE 80

# Comando para iniciar o nginx
CMD ["nginx", "-g", "daemon off;"]
