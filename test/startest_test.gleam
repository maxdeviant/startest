import startest.{describe, it, xit}
import startest/expect

pub fn main() {
  startest.run_tests([
    describe("startest/expect", [
      describe("to_be_ok", [
        describe("given an Ok", [
          it("passes", fn() {
            Ok(Nil)
            |> expect.to_be_ok
          }),
        ]),
      ]),
      it("is Ok", fn() {
        Error("oops")
        |> expect.to_be_ok
      }),
      it("is Error", fn() {
        Ok(42)
        |> expect.to_be_error
      }),
    ]),
    it("passes", fn() {
      2 + 2
      |> expect.to_equal(4)
    }),
    it("fails", fn() {
      3 + 4
      |> expect.to_equal(6)
    }),
    xit("is skipped", fn() {
      1
      |> expect.to_equal(2)
    }),
  ])
}
