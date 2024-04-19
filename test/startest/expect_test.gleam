import startest.{describe, it}
import startest/expect

pub fn expect_test() {
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
  ])
}
