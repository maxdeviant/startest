import startest.{describe, it, xit}
import startest/expect
import startest/test_case.{Test}
import startest/test_tree

pub fn main() {
  startest.run(startest.default_config())
}

pub fn it_tests() {
  describe("it", [
    it("defines a test", fn() {
      let assert test_tree.Test(test_case) = it("tests something", fn() { Nil })

      test_case.name
      |> expect.to_equal("tests something")

      test_case.skipped
      |> expect.to_be_false
    }),
  ])
}

pub fn xit_tests() {
  describe("xit", [
    it("defines a skipped test", fn() {
      let assert test_tree.Test(test_case) = xit("always fails", fn() { panic })

      test_case.name
      |> expect.to_equal("always fails")

      test_case.skipped
      |> expect.to_be_true
    }),
  ])
}
