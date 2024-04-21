import bigben/clock.{type Clock}
import birl.{type Time}
import startest/config.{type Config}
import startest/logger.{type Logger}

/// The Startest context.
pub type Context {
  Context(config: Config, clock: Clock, logger: Logger, started_at: Time)
}
