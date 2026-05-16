# ============================================
# Frontend — Production Dockerfile
# ============================================

# --- Stage 1: Build ---
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Build-time env var — override via Docker build args
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

RUN npm run build

# --- Stage 2: Serve static files ---
FROM node:20-alpine

WORKDIR /app

RUN npm install -g serve

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=build /app/build ./build

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
