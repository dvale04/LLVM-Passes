; ModuleID = 'inputs/div_simple.ll'
source_filename = "inputs/div_simple.ll"

define i32 @test_iv(i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i32 [ 0, %entry ], [ %next, %loop ]
  %next = add i32 %i, 1
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  %i.lcssa = phi i32 [ %i, %loop ]
  ret i32 %i.lcssa
}
