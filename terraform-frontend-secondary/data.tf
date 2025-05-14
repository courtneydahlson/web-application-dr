data "aws_vpc" "main" {
    filter {
        name = "tag:Name"
        values = ["main-vpc"]
    }
}

data "aws_subnet" "private_subnet_1" {
    filter {
        name = "tag:Name"
        values = ["private-subnet-1"]
    }

    filter {
        name = "vpc-id"
        values = [data.aws_vpc.main.id]
    }
}

data "aws_subnet" "private_subnet_2" {
    filter {
        name = "tag:Name"
        values = ["private-subnet-2"]
    }

    filter {
        name = "vpc-id"
        values = [data.aws_vpc.main.id]
    }
}

data "aws_subnet" "public_subnet_1" {
    filter {
        name = "tag:Name"
        values = ["public-subnet-1"]
    }

    filter {
        name = "vpc-id"
        values = [data.aws_vpc.main.id]
    }
}

data "aws_subnet" "public_subnet_2" {
    filter {
        name = "tag:Name"
        values = ["public-subnet-2"]
    }

    filter {
        name = "vpc-id"
        values = [data.aws_vpc.main.id]
    }
}