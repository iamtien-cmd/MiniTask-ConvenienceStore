# Bước 1: Build dự án bằng Maven
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Bước 2: Chạy ứng dụng bằng Java tinh gọn
FROM openjdk:17-jdk-slim
WORKDIR /app
# Lệnh này sẽ gom file .jar sinh ra đổi tên thành app.jar luôn
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]