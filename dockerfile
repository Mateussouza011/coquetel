# Stage 1: Build the Flutter web app
FROM dart:stable AS build

# Install Flutter
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils zip libglu1-mesa && \
    apt-get clean

RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Set up Flutter and verify installation
RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web && \
    flutter doctor -v

# Copy the app files to the container
WORKDIR /app
COPY . .

# Ensure web platform is initialized
RUN flutter create --platforms=web .

# Get app dependencies and build for web
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Create a lightweight web server to serve the app
FROM nginx:alpine

# Copy the build output to the nginx public directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]