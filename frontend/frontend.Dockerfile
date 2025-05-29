# Stage 1: Build the React app
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# ARG REACT_APP_API_URL
# ENV REACT_APP_API_URL=$REACT_APP_API_URL

RUN npm run build

# Stage 2: Serve the built app with Nginx
FROM nginx:alpine

# Copy SSL certificates
COPY nginx/ssl/localhost.crt /etc/ssl/certs/
COPY nginx/ssl/localhost.key /etc/ssl/private/

# Copy custom nginx config
# COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built assets
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]