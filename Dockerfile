# Name the node stage "builder"
FROM node:16.13-alpine AS builder
# Set working directory
WORKDIR /app
# Copy all files from current directory to working dir in image
COPY . .
# install node modules and build assets
RUN npm i && npm run build
# nginx state for serving content
FROM nginx
RUN su
# copy nginx configuration to context
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/certificate
RUN chown -R root:root /etc/nginx/certificate
RUN chmod -R 600 /etc/nginx/certificate
COPY csr.conf /etc/nginx/certificate
COPY cert.conf /etc/nginx/certificate
# generate keys and certificate ssl
RUN openssl genrsa -out server.key 2048
RUN openssl req -new -key server.key -out server.csr -config /etc/nginx/certificate/csr.conf
RUN openssl req -x509 -sha256 -days 356 -nodes -newkey rsa:2048 -subj "/CN=DigiCert SHA2 Extended Validation Server CA/C=CO/L=Bogota/O=DigiCert Inc/OU=www.digicert.com" -keyout rootCA.key -out rootCA.crt
RUN openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -days 365 -sha256 -extfile /etc/nginx/certificate/cert.conf
# copy certificate ssl and key to context
RUN cp server.key /etc/nginx/certificate
RUN cp server.csr /etc/nginx/certificate
RUN cp rootCA.crt /etc/nginx/certificate
RUN cp rootCA.key /etc/nginx/certificate
RUN cp server.crt /etc/nginx/certificate
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY --from=builder /app/dist/client-application .
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
