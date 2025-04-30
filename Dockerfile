# Base image
FROM node:18-bullseye

# Working directory 
<<<<<<< HEAD
WORKDIR /app 

# Copy angular files
COPY angular-site/wsu-hw-ng-main/ ./

RUN apt update && \
<<<<<<< HEAD
    apt install -y nodejs && \ 
    apt install -y npm && \ 
    apt install -y nodejs && \
    apt install -y npm && \

EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0"]
