# Use official Node.js image
FROM node:18

ENV MYSQL_HOST=mysql-db
ENV MYSQL_PORT=3306
ENV MYSQL_USER=root
ENV MYSQL_DB=my_db
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV PHPMYADMIN_URL=http://phpmyadmin:80
ENV PHPMYADMIN_URL_FROM_HOST=http://localhost:8080

# Set working directory
WORKDIR /usr/src/app

# Copy dependencies files
COPY package*.json ./

RUN apt-get update && apt-get install -y iputils-ping


# Install dependencies
RUN npm install

# Copy source files
COPY . .

# Expose port (Express default)
EXPOSE 3000

# Start the app
CMD ["node", "server.js"]
