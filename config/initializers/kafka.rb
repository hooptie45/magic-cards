::KAFKA = Kafka.new(
  seed_brokers: ENV.fetch("KAFKA_SEED_BROKERS", "localhost:9092,kafka:9092").split(","),
  logger: Rails.logger
)
::KAFKA_ASYNC = ::KAFKA.async_producer(delivery_interval: 10)

Kernel.at_exit { ::KAFKA_ASYNC.shutdown }
