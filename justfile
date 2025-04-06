run:
  lapis server

deploy-to-koyeb:
  @./scripts/deploy-to-koyeb.sh

build-swagger:
  @./scripts/build-swagger.sh "http://localhost:8080"
