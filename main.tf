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
  most_recent      = true
  owners           = ["82526582547"]

  filter {
    name = "name"
    values = ["Example application*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example_app" {
  ami           = "${data.aws_ami.example_app.id}"
  instance_type = "t2.micro"
  subnet_id     = "${element(data.terraform_remote_state.core_infra.public_subnet_ids,0)}"
  associate_public_ip_address = true

  tags {
     Name = "${var.instance_name}"
     business_unit = "${var.tag_business_unit}"
     cost_center = "${var.tag_cost_center}"
     environment = "${var.ENVIRONMENT}"
     role = "Notifications"
     Terraform = "True"
   }
}

