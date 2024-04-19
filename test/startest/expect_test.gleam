import startest.{describe, it}
import startest/expect

pub fn suite() {
  describe("startest/expect", [
    describe("to_be_ok", [
      describe("given an Ok", [
        it("passes", fn() {
          Ok(Nil)
          |> expect.to_be_ok
        }),
      ]),
    ]),
  ])
}
