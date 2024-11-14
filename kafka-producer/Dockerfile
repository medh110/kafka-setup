FROM golang:1.20-alpine as builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod tidy
COPY . .
RUN go build -o kafka-producer main.go

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/kafka-producer .
CMD ["./kafka-producer"]
