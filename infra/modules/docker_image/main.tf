resource null_resource ecr_image {
 triggers = {
   python_code       = data.archive_file.src.output_sha
   docker_file       = md5(file("${var.root_app_path}/app/Dockerfile"))
   requirements_file = md5(file("${var.root_app_path}/app/requirements.txt"))
 }
 provisioner "local-exec" {
   command = <<EOF
           aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.region}.amazonaws.com
           cd ${var.root_app_path}/app
           docker build -t ${aws_ecr_repository.repo.repository_url}:${var.image_tag} .
           docker push ${aws_ecr_repository.repo.repository_url}:${var.image_tag}
       EOF
 }
}

resource aws_ecr_repository repo {
 name = var.repository_name
 force_delete = true
}
 
data aws_ecr_image image {
 depends_on = [
   null_resource.ecr_image
 ]
 repository_name = var.repository_name
 image_tag       = var.image_tag
}