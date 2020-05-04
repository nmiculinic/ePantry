package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	envVarKeys := []string{
		"_HANDLER",
		"AWS_REGION",
		"AWS_EXECUTION_ENV",
		"AWS_LAMBDA_FUNCTION_NAME",
		"AWS_LAMBDA_FUNCTION_MEMORY_SIZE",
		"AWS_LAMBDA_FUNCTION_VERSION",
		"AWS_LAMBDA_LOG_GROUP_NAME",
		"AWS_LAMBDA_LOG_STREAM_NAME",
		"LANG",
		"TZ",
		"LAMBDA_TASK_ROOT",
		"LAMBDA_RUNTIME_DIR",
		"PATH",
		"LD_LIBRARY_PATH",
		"AWS_LAMBDA_RUNTIME_API",
	}

	m := make(map[string]string)

	for _, v := range envVarKeys {
		m[v] = os.Getenv(v)
	}

	jsonBytes, err := json.Marshal(m)
	if err != nil {
		log.Fatal("Error in converting map to json")
	}

	rstr := fmt.Sprint(string(jsonBytes))
	return events.APIGatewayProxyResponse{
		Body:       rstr,
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
