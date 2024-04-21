import startest/expect

pub fn a_test() {
  2 + 2
  |> expect.to_equal(4)
}

pub fn another_test() {
  2 + 2 - 1
  |> expect.to_equal(3)
}
