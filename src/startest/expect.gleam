pub fn to_equal(actual: a, expected expected: a) -> Nil {
  case actual == expected {
    True -> Nil
    False -> panic as "not equal"
  }
}
