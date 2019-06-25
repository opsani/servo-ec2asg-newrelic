# Optune Servo with ec2asg (adjust) and NewRelic (measure) drivers

## Build servo container
```
docker build . -t example.com/servo-ec2asg-newrelic
```

## Running servo as a Docker service

### Create a docker secret with your authentication token
```
echo -n 'myToken'|docker secret create optune_auth_token -
```

### Run Servo (as a docker service)
**@@TBD**:  create/mount secrets for `newrelic_account_id`, `newrelic_apm_api_key`, `newrelic_apm_app_id`, `newrelic_insights_query_key`, and the servo `config.yaml`.  

**IMPORTANT** Update the example commands below as needed, e.g., to bind mount config.yaml:  `--mount type=bind,source=/path/to/config.yaml,destination=/servo/config.yaml`

```
docker service create -t --name optune-servo \
    --secret optune_auth_token \
    example.com/servo-ec2asg-newrelic \
    app1 --account myAccount
```

If you named your docker secret anything other than `optune_auth_token`, then specify the path to it:
```
docker service create -t --name optune-servo \
    --secret acme-app1-auth \
    example.com/servo-ec2asg-newrelic \
    app1 --account myAccount  --auth-token /run/secrets/acme-app1-auth
```
