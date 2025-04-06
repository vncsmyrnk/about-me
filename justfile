run:
  lapis server

deploy-to-koyeb:
  @./scripts/deploy-to-koyeb.sh

build-swagger url:
  @./scripts/build-swagger.sh {{url}}
