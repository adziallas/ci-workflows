# backend/Dockerfile
FROM openjdk:17-jdk-slim
COPY target/backend.jar /app/backend.jar
WORKDIR /app
CMD ["java", "-jar", "backend.jar"]
