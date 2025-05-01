# Project 5 #

### Continuous Deployment Project Overview ###
- The goal of this project is to implement semantic versioning using `git tag`
- Using `webhook`s to keep production up to date

## Part One ##

### Generating `tag`s ###
- The command `git tag` will show tags in a `git` repository
- To generate a tag in git use the command `git tag -a v*.*.* -m "version *.*.*"
- The command `git push origin v*.*.*` will push that tag

### Semantic Versioning Container Images with GitHub Actions ###
- My workflow builds a docker image from the repoitory code
  - Runs only when a semantic version tag is pushed
  - Receives the following tags:
    - latest
    - major
    - minor
- Pushes the tagged images to dockerhub
- ` on:
  push:
    tags:
      - 'v*' `
  - This makes it where the workflow is only triggered when a Git tag like `1.1.1` is pushed
  - `- uses: actions/checkout@v3` checks out the code for the build
  - `- uses: docker/setup-buildx-action@v3` sets up docker build
  - `- uses: docker/login-action@v3` logs into dockerhub using credentials from GitHub secrets
  - `- uses: docker/metadata-action@v5` generates a set of tags from my repository
  - `- uses: docker/build-push-action@v5` builds and pushes the image to dockerhub
  - `images: dyoung1023/young-ceg3120` would need to be changed if used in a different repository
- Link to workflow file is:
  - ./.github/workflows/container-push.yml

### Testing & Validating ###
- To test create and push a tag
  - `git tag -a v1.1.6 -m "Testing workflow"` to create tag
  - `git push origin v1.1.6` to push tag
- Should show in terminal, `* [new tag]         v1.1.4 -> v1.1.6` to show it was pushed
- Go to github and go to `Actions` and you should see it running
  - If there is a green checkmark that means it worked
- Go to dockerhub and under the correct repository, look under tags and it should be there
- Use the command associated with the tage to make sure it worked
  - `docker pull dyoung1023/young-ceg3120:1.1.6`
  - `docker run -d -p 4200:4200 dyoung1023/young-ceg3120:1.1.6` to make sure the image runs
  - Go to http://localhost:4200 and you should see the app running (localhost is my ubuntu address)

 ## Part Two ## 

 ### EC2 Instance Details ###
 - The AMI being used is ubuntu (ami-084568db4383264d4)
 - The instance type is t2.medium
 - 30 GB volume size
 - Security groups allows SSH from my IP address on port 22
   - I am the only person who needs to SSH into the instance
- Allows inbound TCP from my home and school IP address
  - In case I am at home or at school my instance can still receive TCP from my local system
- Outbound allows all traffic from anywhere
  - In case I need to send traffic from anywhere from my instance
  
### Docker Setup on OS on the EC2 instance ###
- `sudo apt install docker.io` to install docker to the OS
- After it is installed use `docker login` to login to your dockerhub account
  - It will ask for username (or email) and password to login
- Add docker groups if doesnt exist with `sudo groupadd docker`
  - Use command `sudo gpasswd -a $USER docker`
  - Logout then log back in and this will make it to where you do not need to add sudo before docker commands
- `docker --version` to make sure docker was installed
- `docker run hello-world` to make sure containers are running properly

### Testing on EC2 Instance ###
- Use `docker pull dyoung1023/young-ceg3120:latest` to pull the latest image from dockerhub repository
- Use `docker run -it -p 4200:4200 dyoung1023/young-ceg3120:latest` to get the container running
  - `-it` flag is more interactive and is used for testing and debugging
  - I would recommend the `-d` flag which is detached and can run in the background freely, for after the testing phase
- On your terminal it should show that it has compiled sucessfully
- Go to http://localhost:4200 and you should see the app running (localhost is my ubuntu IP address)
- From inside the instance, using the command `curl http://127.0.0.1:4200` it should show you the contents of the app
- To manually refresh the container
  - Stop the running container and then remove
    - `docker ps` to find the container
    - `docker stop <name>` to stop
    - `docker rm <name>` to remove
  - `docker pull <name>:latest` to get the newest version
  - `docker run -it -p 4200:4200 <name>:latest` to run the latest container 

### Scripting Container Application Refresh ###
- Using `sudo ./app-refresh.sh` to run my script and make sure it works
- use the `docker ps` command to make sure the new container started
- http://localhost:4200 and you should see the app running (localhost is my ubuntu IP address)
- From inside the instance, using the command `curl http://127.0.0.1:4200` it should show you the contents of the app
- Run `sudo ./app-refresh.sh` again
  - Use `docker ps` and you should only see one container still. This means your script is deleting the old containers as well
- Link to bash script
  - ./deployment/app-refresh.sh

### Configuring a `webhook` Listener on EC2 Instance ###
- Use `sudo apt-get install webhook` to install webhook on ubuntu
- Use `webhook --version` to make sure it was installed
  - Something like `webhook version 2.8.0` should show up
- The `webhook` definition file defines a webhook hook
- Use `webook -hooks hook.json -port 9000 -verbose`
  - You see an output like `found 1 hook(s) in file` which shows the definition file was loaded
  - Send a test like `curl -X POST http://34.229.84.76:9000/hooks/refresh-container \
     -H 'Content-Type: application/json' \
     -H 'X-Webhook-Token: my-secret-token' \
     -d '{"event":"test"}'`
    - With the `-verbose` flag it will show how it is running
    - If it is working you should see something like `refresh-container hook triggered successfully`
    - Use `docker ps` to make sure that the container is running
  - Link to definition file
    - ./deployment/hook.json
   
### Configuring a Payload Sender ###
- I chose DockerHub, because
- The payload is triggered when there is a push
- You can verify a successful payload delivery by going to dockerhub and going to webhooks and under view history it will say successful
  - Also, reaading the logs on the terminal will state the success

### Configure a `webhook` Service on EC2 Instance ###
- The webhook service contents allow for webhook to run immeadiately when my EC2 instance starts
- Use `sudo systemctl enable webhook` to enable the webhook
- Use `sudo systemctl start webhook` to start the webhook listener
- Use `sudo systemctl status webhook` to verify it is on
- To verify it is capturing payloads and triggering bash scripts use `tail -f /var/log/webhook.log` to see live
  - `cat /var/log/webhook.log` to see logs
- Link to service file
  - ./deployment/webhook.service

### Resources ###
- https://github.com/adnanh/webhook
- https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151
- https://linuxhandbook.com/create-systemd-services/


  
