# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

ENV MYSQL_HOST=mysqlc
ENV MYSQL_PORT=3306
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=password
ENV MYSQL_DB=test_db

# Copy dependencies files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY . .

# Expose port (Express default)
EXPOSE 5000

# Start the app
CMD ["node", "server.js"]
