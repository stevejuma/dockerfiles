# ShellCheck 

```bash 
 docker buildx ls
 docker buildx create --name multiplatform
 docker buildx use multiplatform
 docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t stevejuma/shellcheck:latest --push .
 docker buildx imagetools inspect stevejuma/shellcheck:latest 
```