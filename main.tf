provider "aws" {
  region = "us-east-1"
}

data "aws_dynamodb_table_item" "hostname_counter" {
  table_name = "hostname-counter"
  key {
    name  = "CounterName"
    value = "hostname"
  }
}

resource "aws_dynamodb_table_item" "increment_hostname_counter" {
  table_name = "hostname-counter"
  hash_key   = "CounterName"
  item = <<ITEM
{
  "CounterName": {"S": "hostname"},
  "CurrentValue": {"N": "${tonumber(data.aws_dynamodb_table_item.hostname_counter.item["CurrentValue"]["N"]) + 1}"}
}
ITEM
}

resource "null_resource" "hostname" {
  provisioner "local-exec" {
    command = "echo ${aws_dynamodb_table_item.increment_hostname_counter.item["CurrentValue"]["N"]}"
  }
}

output "hostname" {
  value = "server-${aws_dynamodb_table_item.increment_hostname_counter.item["CurrentValue"]["N"]}"
}