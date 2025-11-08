define i32 @licm_test(i32 %n, i32 %a, i32 %b) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %invariant1 = mul i32 %a, %b     
  %variant = mul i32 %i, %a        
  %i.next = add i32 %i, 1
  %cond = icmp slt i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:
  ret i32 %invariant1
}