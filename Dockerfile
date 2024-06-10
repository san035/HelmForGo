ARG GOLANG_VERSION=1.20
#ARG PLATFORM=linux/amd64
#ARG IMAGE_RUN=alpine:latest
#ARG PLATFORM=darwin/arm64
ARG PLATFORM=$BUILDPLATFORM
ARG IMAGE_BUILD=arm64v8/golang:alpine
ARG IMAGE_RUN=arm64v8/alpine:latest

FROM golang:${GOLANG_VERSION} AS builder
WORKDIR /app
COPY go.* ./
RUN go mod download -x
ADD . .
RUN #CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/app cmd/main.go
RUN CGO_ENABLED=0 go build -o /app/app cmd/main.go
EXPOSE 8080

FROM --platform=${PLATFORM} arm64v8/alpine:latest
#FROM --platform=${PLATFORM} $(IMAGE_RUN)
RUN apk add --no-cache tzdata
ENV TZ=Europe/Moscow
WORKDIR /app/
COPY --from=builder /app/app /app/local.env .
ENTRYPOINT ["/app/app"]