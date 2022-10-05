name           = "test"
log_group_name = "test"
# task_definition       = "[{\"name\":\"nginx\",\"image\":\"nginx:latest\",\"memory\":256,\"cpu\":256,\"essential\":true,\"portMappings\":[{\"containerPort\":80,\"protocol\":\"tcp\"}],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"awslogs-nginx-ecs\",\"awslogs-region\":\"us-east-1\",\"awslogs-stream-prefix\":\"ecs\"}}}]"
container_definitions = "[{            \"name\": \"dev-test-container1032022\",            \"image\": \"nginx\",            \"memory\": 100,            \"cpu\": 99}]"
