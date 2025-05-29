



cd nginx/ssl
chmod +x generate-certs.sh
./generate-certs.sh



docker build --no-cache -t my-app-image .