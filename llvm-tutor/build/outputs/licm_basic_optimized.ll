; ModuleID = 'inputs/licm_basic.ll'
source_filename = "inputs/licm_basic.ll"

define i32 @licm_test(i32 %n, i32 %a, i32 %b) {
entry:
  %invariant1 = mul i32 %a, %b
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %variant = mul i32 %i, %a
  %i.next = add i32 %i, 1
  %cond = icmp slt i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  %invariant1.lcssa = phi i32 [ %invariant1, %loop ]
  ret i32 %invariant1.lcssa
}
