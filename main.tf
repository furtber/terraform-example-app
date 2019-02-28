# Read subnet ids from core-infra state file

data "terraform_remote_state" "core_infra" {
  backend = "s3"

  config {
    bucket = "terraform-tfstate-825265825471"
    key    = "workspace/${var.ENVIRONMENT}/core-infra.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "example_app" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "Example Application*",
    ]
  }

  owners = ["self"]
}

resource "aws_instance" "example_app" {
  ami           = "${data.aws_ami.amazon_linux.id}"
  instance_type = "t2.micro"
  subnet_id     = "${element(data.terraform_remote_state.core_infra.private_subnet_ids,0)}"

  tags {
     Name = "${var.instance_name}"
     business_unit = "${var.tag_business_unit}"
     cost_center = "${var.tag_cost_center}"
     environment = "${var.ENVIRONMENT}"
     role = "Notifications"
     Terraform = "True"
   }
}

