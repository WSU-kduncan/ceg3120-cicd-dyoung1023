# Base image
FROM node:18-bullseye

# Working directory 
WORKDIR /app

# Copy angular files
COPY angular-site/wsu-hw-ng-main/ ./

RUN apt update && \
    apt install -y nodejs && \
    apt install -y npm && \
    npm install -g @angular/cli

EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0"]
