import startest.{describe, it}
import startest/expect

pub fn describe_tests() {
  describe("example_project", [
    describe("2 + 2", [
      it("= 4", fn() {
        2 + 2
        |> expect.to_equal(4)
      }),
    ]),
  ])
}

pub fn more_describe_tests() {
  describe("example_project", [
    describe("2 + 2 - 1", [
      it("= 3", fn() {
        2 + 2 - 1
        |> expect.to_equal(3)
      }),
    ]),
  ])
}

pub fn it_tests() {
  it("True is true", fn() {
    True
    |> expect.to_be_true
  })
}
