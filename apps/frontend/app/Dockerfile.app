FROM nginx:alpine AS production

# Remove default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Angular dist artifact into Nginx html
COPY dist/app /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]