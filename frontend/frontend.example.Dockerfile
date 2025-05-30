# Stage 1: Builder - Install dependencies and build React app
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies first (cached unless package.json changes)
COPY package.json yarn.lock* package-lock.json* ./
RUN npm ci --omit=dev

# Copy source and build
COPY . .
RUN npm run build

# Stage 2: Development - With live reload and source maps
FROM node:18-alpine AS dev

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY . .

# Install dev dependencies
RUN npm install --only=development

EXPOSE 3000

CMD ["npm", "run", "dev"]

# Stage 3: Production - Optimized Nginx server
FROM nginx:1.25-alpine AS prod

# Remove default nginx config
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx/nginx.conf /etc/nginx/conf.d

# Copy SSL certificates (recommend to use Let's Encrypt in production)
COPY nginx/ssl/localhost.crt /etc/ssl/certs/
COPY nginx/ssl/localhost.key /etc/ssl/private/
# RUN chmod 400 /etc/ssl/private/localhost.key

# Copy built assets from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Security headers and permissions
# RUN chown -R nginx:nginx /usr/share/nginx/html && \
#     chmod -R 755 /usr/share/nginx/html && \
#     find /usr/share/nginx/html -type f -exec chmod 644 {} \;

# # Health check
# HEALTHCHECK --interval=30s --timeout=3s \
#   CMD curl -f http://localhost/ || exit 1

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]