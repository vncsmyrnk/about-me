#!/bin/sh

swagger_url="$1"
swagger_url_escaped=$(echo "$swagger_url" | sed 's/\//\\\//g')

mkdir -p docs/swagger
curl -L https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.20.6.zip -o /tmp/swagger.zip
unzip /tmp/swagger.zip -d /tmp
cp /tmp/swagger-ui-5.20.6/dist/* docs/swagger
sed -i "s/https:\/\/petstore.swagger.io\/v2\/swagger.json/$swagger_url_escaped\/swagger.json/g" docs/swagger/swagger-initializer.js
echo "Done."
