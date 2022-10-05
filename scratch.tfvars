name            = "beaconberef-us_west_2-dev-001-taskdef-000"
task_definition = "[{\"family\":\"webserver\",\"containerDefinitions\":[{\"name\":\"dev-test-container1032022\",\"image\":\"nginx\",\"memory\":100,\"cpu\":99,\"essential\":true,\"portMappings\":[{\"containerPort\":80,\"protocol\":\"tcp\"}]}],\"requiresCompatibilities\":[\"FARGATE\"],\"networkMode\":\"awsvpc\",\"memory\":512,\"cpu\":256}]"
log_group_name = "/dev/ecs/task/beaconberef"
