# Stage 1: Builder
# Installs dependencies and compiles the application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Runner
# Minimal production image with only compiled output and production dependencies
FROM node:20-alpine AS runner

WORKDIR /app

# Add libc6-compat for Alpine compatibility
RUN apk add --no-cache libc6-compat

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nestjs -u 1001

# Copy built application from builder stage
COPY --from=builder /app/dist ./dist

# Copy package files and install production dependencies only
COPY package*.json ./
RUN npm ci --omit=dev

# Change ownership to non-root user
RUN chown -R nestjs:nodejs /app

USER nestjs

# Expose port
EXPOSE 3000

# Environment variable for production
ENV NODE_ENV=production

# Environment variable for port
ENV PORT=3000

# Start the application
CMD ["node", "dist/main.js"]
