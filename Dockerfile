# Build stage
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the entire project
COPY . .

# Build the Next.js app
RUN npm run build

# Production stage
FROM node:18-alpine AS production

# Set the working directory
WORKDIR /app

# Copy the build output from the build stage
COPY --from=build /app/.next ./.next
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json

# Expose the port that Next.js will run on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]
