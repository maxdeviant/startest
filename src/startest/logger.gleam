import gleam/io

pub type Logger {
  Logger
}

pub fn log(_logger: Logger, message: String) -> Nil {
  io.println(message)
}

pub fn error(_logger: Logger, message: String) -> Nil {
  io.println_error(message)
}
