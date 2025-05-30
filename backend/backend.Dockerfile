# Use official Node.js image
FROM node:18

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
