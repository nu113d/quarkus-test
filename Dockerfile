# Maven for building
FROM maven:3.8.7-openjdk-18 AS builder
WORKDIR /app
COPY pom.xml /app
COPY src ./src
RUN mvn package -DskipTests

# Quarkus app in JVM mode (from Dockerfile.jvm)
FROM registry.access.redhat.com/ubi8/openjdk-17:1.20
WORKDIR /app

# Copy the built application
COPY --from=builder /app/target/quarkus-app/lib/ /app/lib/
COPY --from=builder /app/target/quarkus-app/quarkus/ /app/quarkus/
COPY --from=builder /app/target/quarkus-app/app/ /app/app/
COPY --from=builder /app/target/quarkus-app/*.jar /app/quarkus-run.jar

# Run
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "/app/quarkus-run.jar"]