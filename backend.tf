terraform {
  backend "s3" {
    bucket = "demotfstatebuck"
    key    = "backend.tfstate"
    region = "ap-south-1"
  }
}
