variable "bucket_name" {
  type        = string
  description = "The unique name of your portfolio S3 bucket"
  default     = "cloud-accelerator-portfolio-chinonny-v3"
}

variable "ami_id" {
  type        = string
  description = "Ubuntu 24.04 LTS AMI ID"
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "instance_type" {
  type        = string
  description = "Free-tier eligible instance type"
  default     = "t3.micro"
}

variable "my_public_ip" {
  type        = string
  description = "Your home public IP address for secure SSH access"
  default     = "207.216.239.72/32"
}
