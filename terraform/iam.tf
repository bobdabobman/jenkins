resource "aws_iam_role" "jenkins_instance_role" {
  name = "${var.project_name}-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.jenkins_instance_role.name
}

resource "aws_iam_policy" "jenkins_policy" {
  name        = "${var.project_name}-policy"
  description = "Policy for Jenkins server to access AWS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ECR Access
      {
        Effect   = "Allow",
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      },
      # S3 Access (if needed)
      {
        Effect   = "Allow",
        Action   = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "*"
      },
      # ECS Access
      {
        Effect   = "Allow",
        Action   = [
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:ListTasks",
          "ecs:DescribeTasks"
        ],
        Resource = "*"
      },
      # CloudWatch Logs Access
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      # EC2
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateVpc",
          "ec2:DescribeVpcs",
          "ec2:DeleteVpc",
          "ec2:CreateSubnet",
          "ec2:DescribeSubnets",
          "ec2:DeleteSubnet",
          "ec2:CreateRouteTable",
          "ec2:DescribeRouteTables",
          "ec2:AssociateRouteTable",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateTags",
          "ec2:ModifyVpcAttribute",
          "ec2:DescribeVpcAttribute"
        ],
        "Resource": "*"
      },
      # acm
      {
        "Effect": "Allow",
        "Action": [
          "acm:ListCertificates",
          "acm:DescribeCertificate"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_role_policy_attachment" {
  role       = aws_iam_role.jenkins_instance_role.name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}
