#!/bin/bash

DEPLOY_CHECK_TIMEOUT_SECONDS=180
KOYEB_BASE_URL=https://app.koyeb.com/v1

if [ -z $KOYEB_TOKEN ] || [ -z $KOYEB_SERVICEID ]; then
  echo "\$KOYEB_TOKEN and \$KOYEB_SERVICEID must be filled"
  exit 1
fi

status_response_deploy=$(curl -X POST -s \
  --write-out %{http_code} \
   -o /dev/null \
  -H "Authorization: Bearer $KOYEB_TOKEN" \
  $KOYEB_BASE_URL/services/$KOYEB_SERVICEID/redeploy)

if [[ $status_response_deploy != 200 ]]; then
  echo "An error occurred while trying to deploy to koyeb"
  exit 1
fi

echo "Deployment started..."
sleep 2
echo "Checking status..."

start_time=$(date +%s)
deploy_succeeded=0
while (( $(date +%s) - start_time < $DEPLOY_CHECK_TIMEOUT_SECONDS )); do
  service_data=$(curl -s $KOYEB_BASE_URL/services/$KOYEB_SERVICEID -H "Authorization: Bearer $KOYEB_TOKEN")
  active_deployment=$(echo $service_data | jq '.service.active_deployment_id')
  latest_deployment=$(echo $service_data | jq '.service.latest_deployment_id')
  if [[ "$active_deployment" == "$latest_deployment" ]]; then
    echo "Deploy succeeded"
    deploy_succeeded=1
    break
  fi

  time_elapsed=$(($(date +%s) - $start_time))
  TZ=UTC0 printf 'Not finished yet. (%(%H:%M:%S)T)\n' "$time_elapsed"
  sleep 5
done

if [[ "$deploy_succeeded" -eq 0 ]]; then
  echo "Timeout. Deploy may not be successful"
  exit 1
fi
