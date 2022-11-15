FROM ubuntu:18.04 as build
WORKDIR /tmp
RUN apt-get update && apt-get install -y \
    git \
    openjdk-11-jdk
RUN git clone https://gitlab.com/angelorambrosio/k8stest
WORKDIR /tmp/dockerTest
RUN sh ./mvnw clean
RUN sh ./mvnw package -Pprod
RUN cp target/dockerTest.jar dockerTest.jar

FROM adoptopenjdk/openjdk11:jre-11.0.16.1_1
WORKDIR /opt
COPY --from=build /tmp/k8stest/k8sTest-1.0-SNAPSHOT.jar .
EXPOSE 5000
ENTRYPOINT ["java","-jar","/dockerTest.jar"]