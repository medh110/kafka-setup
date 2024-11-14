package main

import (
	"context"

	"github.com/segmentio/kafka-go"
	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
)

const (
	topic          = "message-log"
	broker1Address = "localhost:9092"
)

func consume(ctx context.Context) {
	r := kafka.NewReader(kafka.ReaderConfig{
		Brokers: []string{broker1Address},
		Topic:   topic,
		GroupID: "my-group",
	})
	for {
		msg, err := r.ReadMessage(ctx)
		if err != nil {
			panic("could not read message " + err.Error())
		}
		log.WithFields(log.Fields{"message": string(msg.Value)}).Info("consumer received")
	}
}

func main() {
	logrus.SetFormatter(new(logrus.JSONFormatter))
	ctx := context.Background()
	consume(ctx)
}