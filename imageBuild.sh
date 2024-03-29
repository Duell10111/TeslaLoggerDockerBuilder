#!/usr/bin/env bash

## Testing
#REGISTRY=ghcr.io
#WEB_SERVER_IMAGE_NAME="webserver"
#TESLA_LOGGER_IMAGE_NAME="tesla-logger"
## ---

IMAGE_PREFIX="duell10111/teslalogger"
LOCAL_WEBSERVER_IMAGE="teslalogger-webserver:latest"
LOCAL_TESLALOGGER_IMAGE="teslalogger-teslalogger:latest"

git clone https://github.com/bassmaster187/TeslaLogger
cd TeslaLogger || exit 1
LATEST_TAG=$(git tag | sort --version-sort | tail -n1)

if ! (docker manifest inspect "$REGISTRY/$IMAGE_PREFIX/$WEB_SERVER_IMAGE_NAME:$LATEST_TAG" || docker manifest inspect "$REGISTRY/$IMAGE_PREFIX/$TESLA_LOGGER_IMAGE_NAME:$LATEST_TAG"); then
  echo "Images not found for tag $LATEST_TAG"
  exit 1
fi

echo "Checking out tag: $LATEST_TAG"
git checkout "$LATEST_TAG"

echo "Building Images"
docker-compose build

docker image tag "$LOCAL_WEBSERVER_IMAGE" "$REGISTRY/$IMAGE_PREFIX/$WEB_SERVER_IMAGE_NAME:$LATEST_TAG"
docker image tag "$LOCAL_TESLALOGGER_IMAGE" "$REGISTRY/$IMAGE_PREFIX/$TESLA_LOGGER_IMAGE_NAME:$LATEST_TAG"

docker push "$REGISTRY/$IMAGE_PREFIX/$WEB_SERVER_IMAGE_NAME:$LATEST_TAG"
docker push "$REGISTRY/$IMAGE_PREFIX/$TESLA_LOGGER_IMAGE_NAME:$LATEST_TAG"
