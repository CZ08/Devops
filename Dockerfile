FROM alpine:3.20
RUN apk add --no-cache openjdk11
EXPOSE 80
CMD ["java"]
