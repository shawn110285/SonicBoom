/* verilator lint_off UNOPTFLAT */

module EICG_wrapper(
  output out,
  input en,
  input test_en,
  input in
);

  reg en_latched /*verilator clock_enable*/;

  /* verilator lint_off LATCH */
  always @(*) begin
     if (!in) begin
        en_latched = en || test_en;
     end
  end
  /* verilator lint_on LATCH */

  assign out = en_latched && in;

endmodule
