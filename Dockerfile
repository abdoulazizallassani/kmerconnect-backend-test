FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY mvnw pom.xml ./
COPY .mvn/ .mvn/
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline -B
COPY src ./src
ENV LANG=C.UTF-8
ENV MAVEN_OPTS="-Dfile.encoding=UTF-8"
RUN ./mvnw clean package -DskipTests


FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
RUN addgroup -S spring && adduser -S spring -G spring
USER spring
ENV SERVER_PORT=8080
ENV SPRING_PROFILES_ACTIVE=prod
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
