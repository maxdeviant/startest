import startest.{it, xit}
import startest/expect

pub fn main() {
  startest.run_tests([
    it("passes", fn() {
      2 + 2
      |> expect.to_equal(4)
    }),
    it("fails", fn() {
      3 + 4
      |> expect.to_equal(6)
    }),
    xit("skipped", fn() {
      1
      |> expect.to_equal(2)
    }),
  ])
}
