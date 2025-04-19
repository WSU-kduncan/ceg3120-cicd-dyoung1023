# Project 4

## Part 1
- The OS used is Ubuntu
### Docker Setup
- `sudo apt update` to make sure everything is up to date
- `sudo apt install docker.io` to install docker to the OS
- After it is installed use `docker login` to login to your dockerhub account
  - It will ask for username (or email) and password to login
- Add docker groups if doesnt exist with `sudo groupadd docker`
  - Use command `sudo gpasswd -a $USER docker`
  - Logout then log back in and this will make it to where you do not need to add `sudo` before docker commands
- `docker --version` to make sure docker was installed
- `docker run hello-world` to make sure containers are running properly
  
### Manually Setting up a Container
- `docker pull node:18-bullseye` to pull the node image
- Next we will mount the angular app into the container with:
  - `docker run -it -v /home/ubuntu/ceg3120-cicd-dyoung1023/angular-site/wsu-hw-ng-main:/app -w /app -p 4200:4200 node:18-bullseye bash `
  - `-i` keep stdin open even if not attached
  - `-t` allocates a psuedo-tty and attach to the standard input of the container
  -  `-v ` bind mounts the angular app and the container
  -  `-w /app` sets working directory to /app
  -  `-p` expose container port to host port
- Once in the container use the commands:
  - `apt update` to be able to install
  - `apt install nodejs`
  - `apt install npm`
  - `npm install -g @angular/cli`
- Go into the /app directory where your angualar files should be
- Use the command `ng serve --host 0.0.0.0
  - Eventually it should say `Compiled successfully` to know it is running
  - Go to http://[localhost:4200/](http://54.234.217.189:4200/) and you should see the app (This is my ubuntu public IP)
    
### `Dockerfile` & Building Images
- Once the `Dockerfile` is created (comments in file)
- Use command `docker build -t angular-app . ` to build the image
- `docker run -d -p 4200:4200` to run the container
- Use `docker ps` and you should see the container to make sure it is up
- Go to your browser and put in http://localhost:4200 and the app will come up

### Working with DockerHub Repository 
- Go to Dockerhub.com and sign in
  - Go to repositories and click `Create a repository`
- On Dockerhub.com and singed into your account
  - Go to account settings < Personal access tokens < Generate new token
    - Make a description (access from ubuntu instance)
    - Make expiration for 30 days
    - Give Read & Write permissions only
    - Copy PAT
- I will then use ` docker login -u dyoung1023`
  - Then at the password enter the PAT to login through command line
- `docker tag angular-docker dyoung1023/young-ceg3120:latest` to tag the container
- `docker push dyoung1023/young-ceg3120:latest` to push the container into the `young-ceg3120` repository

## Part 2
### Configuring GitHub Repository Secrets
- On Dockerhub.com and singed into your account
  - Go to account settings < Personal access tokens < Generate new token
    - Make a description (github access)
    - Make expiration for 30 days
    - Give Read & Write permissions only
    - Copy PAT
- Go to github.com
- Go to the correct repository
  - Settings > Security > Secrets and variables > Actions
    - Add new secret
    - Name it `DOCKER_USERNAME`
      - Input username on dockerhub
      - press `Add secret`
    - Add new secret
      - Name it `DOCKER_TOKEN`
        - Paste PAT
        - Press `Add secret`

### CI with GitHub Actions
- My workflow 
### Testing & Validating


## Resources
* https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04
* https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo
* https://github.com/WSU-kduncan/CEG3120/blob/main/CourseNotes/containers.md
* https://dev.to/rodrigokamada/creating-and-running-an-angular-application-in-a-docker-container-40mk
* https://docs.docker.com/engine/storage/bind-mounts/
* https://github.com/pattonsgirl/CEG3120/blob/main/CourseNotes/github-actions.md
