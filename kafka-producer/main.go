package main

import (
	"context"
	"strconv"
	"time"

	"github.com/segmentio/kafka-go"
	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
)

const (
	topic          = "message-log"
	broker1Address = "kafka.default.svc.cluster.local:9092"
)

func produce(ctx context.Context) {
	i := 0

	w := kafka.NewWriter(kafka.WriterConfig{
		Brokers: []string{broker1Address},
		Topic:   topic,
	})

	for {
		err := w.WriteMessages(ctx, kafka.Message{
			Key:   []byte(strconv.Itoa(i)),
			Value: []byte("this is message" + strconv.Itoa(i)),
		})
		if err != nil {
			panic("could not write message " + err.Error())
		}

		log.WithFields(log.Fields{"message": i}).Info("producer writes")
		i++

		time.Sleep(time.Second)
	}
}

func main() {
	logrus.SetFormatter(new(logrus.JSONFormatter))
	ctx := context.Background()
	produce(ctx)
}
