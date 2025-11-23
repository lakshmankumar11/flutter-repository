# Use a recent Flutter version (3.24+) that includes Dart 3.8+
FROM ghcr.io/cirruslabs/flutter:3.24.3 AS build

# Optional: create a non-root user
RUN useradd -ms /bin/bash flutteruser
USER flutteruser

WORKDIR /app
COPY --chown=flutteruser:flutteruser . .

# Install dependencies
RUN flutter pub get

# Build Flutter Web
RUN flutter build web --release --web-renderer canvaskit

# Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
