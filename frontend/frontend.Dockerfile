# Stage 1: Build the React app
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

RUN npm run build

# Stage 2: Serve the built app with Nginx
FROM nginx:alpine AS prod

# Remove default Nginx config
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy custom Nginx config
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificates
COPY nginx/ssl/localhost.crt /etc/ssl/certs/
COPY nginx/ssl/localhost.key /etc/ssl/private/

# Copy built assets
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

