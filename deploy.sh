# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

configure_aws_cli(){
	aws --version
	aws configure set default.region eu-west-1
	aws configure set default.output json
}

push_ecr_image(){
	eval $(aws ecr get-login --region eu-west-1 --no-include-email)
	docker push $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/clippers-quay:$CIRCLE_SHA1
}

configure_aws_cli
push_ecr_image