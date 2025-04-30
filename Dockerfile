# Base image
FROM node:18-bullseye

# Working directory 
WORKDIR /app 

# Copy angular files
COPY angular-site/wsu-hw-ng-main/ ./

RUN apt update && \
    npm install -g @angular/cli \
    npm install

EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0"]
