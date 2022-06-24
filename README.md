[![Build Status](https://github.com/philips-software/docker-blackduck/workflows/build/badge.svg)](https://github.com/philips-software/docker-blackduck/actions/)
[![Slack](https://philips-software-slackin.now.sh/badge.svg)](https://philips-software-slackin.now.sh)

# Docker images

This repo will contain docker images with [Blackduck](https://www.blackducksoftware.com/)

Current versions available:

```
.
├── 7
│   ├── golang
│   ├── java
│   ├── node
│   ├── python
│   ├── dotnetcore-2.2.110
│   ├── dotnetcore-3.0.101
│   ├── dotnetcore-3.1.102
│   └── dotnetcore-3.1.302
│   └── docker
```

## Usage

Images can be found on [https://hub.docker.com/r/philipssoftware/blackduck/](https://hub.docker.com/r/philipssoftware/blackduck/).

``` bash
docker run philipssoftware/blackduck:7 /app/detect.sh --help
docker run philipssoftware/blackduck:7 /app/detect.sh -hv 
```

In order to analyse a project use the following structure.

_Replace all <your-xxxxx> variables with your own variables_

###### Source code scan
``` bash
docker run -v $(pwd):/code philipssoftware/blackduck:7 /app/detect.sh \
  --blackduck.url=<your-blackduck-url> \
  --blackduck.api.token=<your-token> \
  --detect.policy.check=true \
  --detect.source.path=/code \
  --detect.project.name=<your-project-name> \
  --detect.project.version.name=<your-version>
```

###### Docker image scan
``` bash
# If you can share docker mount with blackduck imageinspector
docker run -v /var/run/docker.sock:/var/run/docker.sock --network="host" philipssoftware/blackduck:7-docker \
  /app/detect.sh --blackduck.url=<your-blackduck-url> --blackduck.api.token=<your-token> --detect.policy.check=true \
  --detect.project.name=<your-project-name> --detect.project.version.name=<your-version> --detect.docker.image=<your-image>

# If you want to mount and provide blackduck imageinspector working directory
mkdir $(pwd)/shared
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):$(pwd) --network="host" -w $(pwd) philipssoftware/blackduck:7-docker \
  /airgap/packaged-inspectors/docker/blackduck-docker-inspector.sh --blackduck.url=<your-blackduck-url> --blackduck.api.token=<your-token> \
  --detect.policy.check=true --detect.project.name=<your-project-name> --detect.project.version.name=<your-version> \ 
  --detect.docker.image=<your-image> --shared.dir.path.local=$(pwd)/shared
```



### Air Gap

By setting setting the environment variable `DETECT_AIR_GAP` to `true` you can enable [Air Gap](https://synopsys.atlassian.net/wiki/spaces/INTDOCS/pages/88506397/Running+Synopsys+Detect+in+Air+Gap+Offline+and+Dry+Run+Modes). This eliminate the need for internet access that Detect requires to download those dependencies. Currently only the `gradle` inspector is supported. This mode is particularly useful when you are behind a corporate firewall which blocks connections to JFrog Artifactory.

Example:

```bash
docker run -e DETECT_AIR_GAP=true -v $(pwd):/code philipssoftware/blackduck:6 /app/detect.sh --blackduck.url=<your-blackduck-url> --blackduck.api.token=<your-token> --blackduck.trust.cert=true --detect.policy.check=true --detect.source.path=/code --detect.project.name=<your-project-name> --detect.project.version.name=<your-version>
```

## Content

The images obviously contain blackduck and java8, but also two other files:

- `REPO`
- `TAGS`

### REPO

This file has a url to the REPO with specific commit-sha of the build.
Example: 

```
$ docker run philipssoftware/blackduck:6 cat REPO
https://github.com/philips-software/docker-blackduck/tree/facb2271e5a563e5d6f65ca3f475cefac37b8b6c
```

### TAGS

This contains all the similar tags at the point of creation. 

```
$ docker run philipssoftware/blackduck:6 cat TAGS
blackduck blackduck:6 blackduck:6.7 blackduck:6.7.0
```

You can use this to pin down a version of the container from an existing development build for production. When using `blackduck:6` for development. This ensures that you've got all security updates in your build. If you want to pin the version of your image down for production, you can use this file inside of the container to look for the most specific tag, the last one.

## Simple Tags

### blackduck
- `blackduck`, `blackduck:7`, `blackduck:7.14`, `blackduck:7.14.0` [7/java/Dockerfile](7/java/Dockerfile)

### blackduck with node
- `blackduck:node`, `blackduck:7-node`, `blackduck:7.14-node`, `blackduck:7.14.0-node` [7/node/Dockerfile](7/node/Dockerfile)

### blackduck with python
- `blackduck:python`, `blackduck:7-python`, `blackduck:7.14-python`, `blackduck:7.14.0-python` [7/python/Dockerfile](7/python/Dockerfile)

### blackduck with golang
- `blackduck:golang`, `blackduck:7-golang`, `blackduck:7.14-golang`, `blackduck:7.14.0-golang` [7/golang/Dockerfile](7/golang/Dockerfile)

### blackduck with dotnetcore-2.2.110
- `blackduck:dotnetcore-2.2.110`, `blackduck:7-dotnetcore-2.2`, `blackduck:7.14-dotnetcore-2.2.110`, `blackduck:7.14.0-dotnetcore-2.2.110` [7/dotnetcore-2.2.110/Dockerfile](7/dotnetcore-2.2.110/Dockerfile)

### blackduck with dotnetcore-3.0.101
- `blackduck:7.14-dotnetcore-3.0`, `blackduck:7.14.0-dotnetcore-3.0.101` [7/dotnetcore-3.0.101/Dockerfile](7/dotnetcore-3.0.101/Dockerfile)

### blackduck with dotnetcore-3.1.102
- `blackduck:7.14.0-dotnetcore-3.1.102` [7/dotnetcore-3.1.102/Dockerfile](7/dotnetcore-3.1.102/Dockerfile)

### blackduck with dotnetcore-3.1.302
- `blackduck:dotnetcore`, `blackduck:7-dotnetcore`, `blackduck:7-dotnetcore-3`, `blackduck:7-dotnetcore-3.1`, `blackduck:7.14-dotnetcore`, `blackduck:7.-dotnetcore-3.1`, `blackduck:7.14.0-dotnetcore`, `blackduck:7.14.0-dotnetcore-3.1.302` [7/dotnetcore-3.1.302/Dockerfile](7/dotnetcore-3.1.302/Dockerfile)

### blackduck with docker detector
- `blackduck:docker`, `blackduck:7-docker`, `blackduck:7.14-docker`, `blackduck:7.14.0-docker` [7/docker/Dockerfile](7/docker/Dockerfile)

## Why

> Why do we have our own docker image definitions?

We often need some tools in a container for checking some things. F.e. [jq](https://stedolan.github.io/jq/), [aws-cli](https://aws.amazon.com/cli/) and [curl](https://curl.haxx.se/).
We can install this every time we need a container, but having this baked into a container seems a better approach.

That's why we want our own docker file definitions.

## Known Issues

Currently this image only has java. Running a project with `yarn` or `npm` will not work yet.

## Issues

- If you have an issue: report it on the [issue tracker](https://github.com/philips-software/docker-blackduck/issues)

## License

License is MIT. See [LICENSE file](LICENSE.md)

## Contributors

[//]: contributor-faces
<a href="https://github.com/JeroenKnoops"><img src="https://avatars.githubusercontent.com/u/10019?v=4" title="JeroenKnoops" width="80" height="80"></a>
<a href="https://github.com/bartgolsteijn"><img src="https://avatars.githubusercontent.com/u/3263880?v=4" title="bartgolsteijn" width="80" height="80"></a>
<a href="https://github.com/loafoe"><img src="https://avatars.githubusercontent.com/u/14123216?v=4" title="loafoe" width="80" height="80"></a>
<a href="https://github.com/kishoreinvits"><img src="https://avatars.githubusercontent.com/u/6522155?v=4" title="kishoreinvits" width="80" height="80"></a>
<a href="https://github.com/marcofranssen"><img src="https://avatars.githubusercontent.com/u/694733?v=4" title="marcofranssen" width="80" height="80"></a>
<a href="https://github.com/prakashguru"><img src="https://avatars.githubusercontent.com/u/11089125?v=4" title="prakashguru" width="80" height="80"></a>
<a href="https://github.com/dmixonphilips"><img src="https://avatars.githubusercontent.com/u/56551812?v=4" title="dmixonphilips" width="80" height="80"></a>
<a href="https://github.com/sudheeshps"><img src="https://avatars.githubusercontent.com/u/40300928?v=4" title="sudheeshps" width="80" height="80"></a>
<a href="https://github.com/marcel-dias"><img src="https://avatars.githubusercontent.com/u/233598?v=4" title="marcel-dias" width="80" height="80"></a>
<a href="https://github.com/timovandeput"><img src="https://avatars.githubusercontent.com/u/5458560?v=4" title="timovandeput" width="80" height="80"></a>

[//]: contributor-faces

## Philips Forest

This module is part of the Philips Forest.

```
                                                     ___                   _
                                                    / __\__  _ __ ___  ___| |_
                                                   / _\/ _ \| '__/ _ \/ __| __|
                                                  / / | (_) | | |  __/\__ \ |_
                                                  \/   \___/|_|  \___||___/\__|  

                                                                 Infrastructure
```

Talk to the forestkeepers in the `docker-images`-channel on Slack.

[![Slack](https://philips-software-slackin.now.sh/badge.svg)](https://philips-software-slackin.now.sh)
