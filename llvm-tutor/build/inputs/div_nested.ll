; div_nested.ll
; Test for identifying induction variables in nested loops

define void @nested_loop() {
entry:
  br label %outer

outer:
  %i = phi i32 [0, %entry], [%i.next, %outer.inc]
  br label %inner

inner:
  %j = phi i32 [0, %outer], [%j.next, %inner.inc]
  ; do some computation
  %mul = mul i32 %i, %j
  br label %inner.inc

inner.inc:
  %j.next = add i32 %j, 1
  %cmp.inner = icmp slt i32 %j.next, 4
  br i1 %cmp.inner, label %inner, label %outer.inc

outer.inc:
  %i.next = add i32 %i, 1
  %cmp.outer = icmp slt i32 %i.next, 3
  br i1 %cmp.outer, label %outer, label %exit

exit:
  ret void
}
