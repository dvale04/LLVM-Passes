; test_ive.ll
; Simple loop with a PHI induction variable

define i32 @test_iv(i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [0, %entry], [%next, %loop]
  %next = add i32 %i, 1
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %loop, label %exit

exit:
  ret i32 %i
}
