output "url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.main.repository_url
}
