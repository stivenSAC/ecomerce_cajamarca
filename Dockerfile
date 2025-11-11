# Multi-stage build para el backend
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY E-comerce_Mujeres_Cajamarca/pom.xml .
COPY E-comerce_Mujeres_Cajamarca/src ./src
RUN mvn clean package -DskipTests

FROM openjdk:17-jre-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8085
CMD ["java", "-jar", "app.jar"]