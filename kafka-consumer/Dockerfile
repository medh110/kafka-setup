FROM golang:1.20-alpine as builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod tidy
COPY . .
RUN go build -o kafka-consumer main.go

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/kafka-consumer .
CMD ["./kafka-consumer"]
