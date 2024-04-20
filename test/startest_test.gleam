import startest.{it, xit}
import startest/expect
import startest/expect_test
import startest/reporters/default as default_reporter

pub fn main() {
  let reporters = [default_reporter.new()]

  [
    expect_test.suite(),
    it("passes", fn() {
      2 + 2
      |> expect.to_equal(4)
    }),
    xit("fails", fn() {
      3 + 4
      |> expect.to_equal(6)
    }),
    xit("is Ok", fn() {
      Error("oops")
      |> expect.to_be_ok
    }),
    xit("is Error", fn() {
      Ok(42)
      |> expect.to_be_error
    }),
    xit("is skipped", fn() {
      1
      |> expect.to_equal(2)
    }),
  ]
  |> startest.run_tests(reporters)
}
