# Project 5 #
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
  - `git tag -a v1.1.4 -m "Testing workflow"` to create tag
  - `git push origin v1.1.4` to push tag
- Should show in terminal, `* [new tag]         v1.1.4 -> v1.1.4` to show it was pushed
- Go to github and go to `Actions` and you should see it running
  - If there is a green checkmark that means it worked
- Go to dockerhub and under the correct repository, look under tags and it should be there
- Use the command associated with the tage to make sure it worked
  - `docker pull dyoung1023/young-ceg3120:1.1.4`
  - `docker run -rm dyoung1023/young-ceg3120:1.1.4` to make sure the image runs




  
