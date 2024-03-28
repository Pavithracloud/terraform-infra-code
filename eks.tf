resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster-${var.cluster_name}"
assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

################
resource "aws_iam_role_policy_attachment" "demo-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster.name
}

###############

resource "aws_iam_role_policy_attachment" "amazon-eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-cluster.arn
  vpc_config {
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids = ["${module.dev_vpc.private_subnet_1.id}","${module.dev_vpc.private_subnet_2.id}","${module.dev_vpc.public_subnet_1.id}","${module.dev_vpc.public_subnet_2.id}"]
  }
  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy,aws_iam_role_policy_attachment.demo-AmazonEKSServicePolicy]
}



################variable and provider#################



variable "cluster_name" {
  default = "demo"
}

variable "cluster_version" {
  default = "1.27"
}




#############################################################

resource "aws_iam_role" "eks-fargate-profile" {
  name = "eks-fargate-profile"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "eks-fargate-profile" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks-fargate-profile.name
}



######################################

resource "aws_eks_fargate_profile" "kube-system" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn
   subnet_ids = ["${module.dev_vpc.private_subnet_1.id}","${module.dev_vpc.private_subnet_2.id}"]
  selector {
    namespace = "kube-system"
  }
  selector {
    namespace = "staging"
  }
}
