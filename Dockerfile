# Use a lightweight JRE base image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged jar file into the container
# The Jenkins pipeline will generate this in the target/ directory
COPY target/*.jar app.jar

# Expose the port the Spring Boot app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]