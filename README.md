[![Build Status](https://github.com/philips-software/docker-blackduck/workflows/build/badge.svg)](https://github.com/philips-software/docker-blackduck/actions/)
[![Slack](https://philips-software-slackin.now.sh/badge.svg)](https://philips-software-slackin.now.sh)

# Docker images

This repo will contain docker images with [Blackduck](https://www.blackducksoftware.com/)

Current versions available:
```
.
├── 5
│   ├── java
│   │   └── Dockerfile
│   └── node
│       └── Dockerfile

```
## Usage

Images can be found on [https://hub.docker.com/r/philipssoftware/blackduck/](https://hub.docker.com/r/philipssoftware/blackduck/).

``` bash
docker run philipssoftware/blackduck:5 /app/detect.sh --help
docker run philipssoftware/blackduck:5 /app/detect.sh -hv 
```

In order to analyse a project use the following structure.

_Replace all <your-xxxxx> variables with your own variables_

``` bash
docker run -v $(pwd):/code db /app/detect.sh --blackduck.url=<your-blackduck-url> --blackduck.api.token=<your-token> --blackduck.trust.cert=true --detect.policy.check=true --detect.source.path=/code --detect.project.name=<your-project-name> --detect.project.version.name=<your-version>
```

## Content

The images obviously contain blackduck and java8, but also two other files:
- `REPO`
- `TAGS`

### REPO

This file has a url to the REPO with specific commit-sha of the build.
Example: 

```
$ docker run philipssoftware/blackduck:5 cat REPO
https://github.com/philips-software/docker-blackduck/tree/facb2271e5a563e5d6f65ca3f475cefac37b8b6c
```

### TAGS

This contains all the similar tags at the point of creation. 

```
$ docker run philipssoftware/blackduck:5 cat TAGS
blackduck blackduck:5 blackduck:5.4 blackduck:5.4.0
```

You can use this to pin down a version of the container from an existing development build for production. When using `blackduck:5` for development. This ensures that you've got all security updates in your build. If you want to pin the version of your image down for production, you can use this file inside of the container to look for the most specific tag, the last one.

## Simple Tags

### blackduck
- `blackduck`, `blackduck:5`, `blackduck:5.4`, `blackduck:5.4.0` [5/java/Dockerfile](5/java/Dockerfile)

### blackduck with node
- `blackduck:node`, `blackduck:5-node`, `blackduck:5.4-node`, `blackduck:5.4.0-node` [5/node/Dockerfile](5/node/Dockerfile)

## Why

> Why do we have our own docker image definitions?

We often need some tools in a container for checking some things. F.e. [jq](https://stedolan.github.io/jq/), [aws-cli](https://aws.amazon.com/cli/) and [curl](https://curl.haxx.se/).
We can install this every time we need a container, but having this baked into a container seems a better approach.

That's why we want our own docker file definitions.

## Known Issues

Currently this image only has java. Running a project with `yarn` or `npm` will not work yet.

## Issues

- If you have an issue: report it on the [issue tracker](https://github.com/philips-software/docker-blackduck/issues)

## Author

- Jeroen Knoops <jeroen.knoops@philips.com>
- Heijden, Remco van der <remco.van.der.heijden@philips.com>

## License

License is MIT. See [LICENSE file](LICENSE.md)

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
