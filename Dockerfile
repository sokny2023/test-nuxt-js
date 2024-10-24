# Stage 1: Build
FROM node:18 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Nuxt.js application
RUN npm run build

# Stage 2: Production
FROM node:18 AS production

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/.nuxt .nuxt
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

# Set the environment variable
ENV NODE_ENV=production

# Expose the application port (default is 3000 for Nuxt)
EXPOSE 3000

# Start the Nuxt.js application
CMD ["npm", "run", "start"]
