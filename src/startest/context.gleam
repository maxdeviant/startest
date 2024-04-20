import startest/config.{type Config}
import startest/logger.{type Logger}

/// The Startest context.
pub type Context {
  Context(config: Config, logger: Logger)
}
