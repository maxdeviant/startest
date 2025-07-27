import bigben/clock.{type Clock}
import gleam/time/timestamp.{type Timestamp}
import startest/config.{type Config}
import startest/logger.{type Logger}

/// The Startest context.
pub type Context {
  Context(config: Config, clock: Clock, logger: Logger, started_at: Timestamp)
}
