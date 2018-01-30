# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

configure_aws_cli(){
	aws --version
	aws configure set default.region eu-west-1
	aws configure set default.output json
}

push_ecr_image(){
    docker build -t clippers-quay-dev:$CIRCLE_SHA1 .

    docker tag clippers-quay-dev:$CIRCLE_SHA1 $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/clippers-quay-dev:$CIRCLE_SHA1

	eval $(aws ecr get-login --region eu-west-1 --no-include-email)

	docker push $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/clippers-quay-dev:latest
}

deploy_cluster() {

    family="cq-website-task"

    create_task_def
    register_task_def

    if [[ $(aws ecs update-service --cluster development --service website --task-definition $revision | \
                   $JQ '.service.taskDefinition') != $revision ]]; then
        echo "Error updating service."
        return 1
    fi

    # wait for older revisions to disappear
    # not really necessary, but nice for demos
    for attempt in {1..30}; do
        if stale=$(aws ecs describe-services --cluster development --services website | \
                       $JQ ".services[0].deployments | .[] | select(.taskDefinition != \"$revision\") | .taskDefinition"); then
            echo "Waiting for stale deployments:"
            echo "$stale"
            sleep 5
        else
            echo "Deployed!"
            return 0
        fi
    done
    echo "Service update took too long."
    return 1
}

create_task_def(){
	task_template='[
		{
			"name": "ClippersQuayWebsiteDev",
			"image": "%s.dkr.ecr.eu-west-1.amazonaws.com/clippers-quay-dev:%s",
			"essential": true,
			"memory": 128,
			"cpu": 0,
			"portMappings": [
				{
                    "hostPort": 80,
                    "protocol": "tcp",
                    "containerPort": 5000
				}
			],
			"command": [
                "yarn",
                "serve"
            ],
            "workingDirectory": "/app"
		}
	]'

	task_def=$(printf "$task_template" $AWS_ACCOUNT_ID $CIRCLE_SHA1)
}

register_task_def() {

    if revision=$(aws ecs register-task-definition --container-definitions "$task_def" --family $family | $JQ '.taskDefinition.taskDefinitionArn'); then
        echo "Revision: $revision"
    else
        echo "Failed to register task definition"
        return 1
    fi

}

configure_aws_cli
push_ecr_image
deploy_cluster
