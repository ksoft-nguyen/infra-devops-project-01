FROM node:20-alpine

WORKDIR /app

# Install dependencies required by bcrypt (native addon)
RUN apk add --no-cache python3 make g++

COPY package*.json ./

RUN npm install --omit=dev && npm cache clean --force

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY . .

# Own the app files as the non-root user
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE ${PORT}

CMD ["node", "server.js"]
