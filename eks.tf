# USAR VPC PADRÃO DA CONTA AWS
data "aws_vpc" "default" {
  default = true
}

# USAR SUBREDES DENTRO DA VPC PADRÃO DA CONTA AWS
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
########################################################

# SECURITY GROUP PARA O CLUSTER EKS
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "SG para comunicacao entre o cluster EKS e os worker nodes."
  vpc_id      = data.aws_vpc.default.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
########################################################

# CRIA O CLUSTER EKS
resource "aws_eks_cluster" "fiap-soat-eks-cluster" {
  name     = "fiap-soat-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.32" 

  vpc_config {
    subnet_ids         = data.aws_subnets.default.ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
  tags = { Name = "fiap-soat-eks-cluster-tag" }
}
########################################################

# CONIFGURA O GRUPO DE NÓS COM INSTANCIAS EC2
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.fiap-soat-eks-cluster.name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.default.ids
  instance_types  = [var.instance_type] 
  ami_type        = "AL2_x86_64"
  disk_size       = 20
  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
  tags = {
    "eks:cluster-name" = aws_eks_cluster.fiap-soat-eks-cluster.name
    Name               = "fiap-soat-eks-node-tag"
  }
}
########################################################
