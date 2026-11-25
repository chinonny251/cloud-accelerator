# Step 1: Use an ultra-lightweight Node runtime based on Alpine Linux
FROM node:18-alpine

# Step 2: Establish an absolute working directory path inside the sandbox container
WORKDIR /usr/src/app

# Step 3: Copy your application source code file into the container workspace
COPY server.js .

# Step 4: Document the internal networking port the app listens on
EXPOSE 80

# Step 5: Define the immutable default runtime execution command
CMD ["node", "server.js"]
