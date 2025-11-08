; ModuleID = 'input_for_fcmp_eq.ll'
source_filename = "inputs/input_for_fcmp_eq.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx15.0.0"

; Function Attrs: noinline nounwind ssp uwtable
define double @sqrt_impl(double noundef %0, double noundef %1, double noundef %2) #0 {
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  store double %0, ptr %5, align 8
  store double %1, ptr %6, align 8
  store double %2, ptr %7, align 8
  %9 = load double, ptr %6, align 8
  %10 = load double, ptr %7, align 8
  %11 = fsub double %9, %10
  %12 = bitcast double %11 to i64
  %13 = and i64 %12, 9223372036854775807
  %14 = bitcast i64 %13 to double
  %15 = fcmp olt double %14, 0x3CB0000000000000
  br i1 %15, label %16, label %18

16:                                               ; preds = %3
  %17 = load double, ptr %7, align 8
  store double %17, ptr %4, align 8
  br label %40

18:                                               ; preds = %3
  %19 = load double, ptr %7, align 8
  %20 = load double, ptr %6, align 8
  %21 = fadd double %19, %20
  %22 = fadd double %21, 1.000000e+00
  %23 = fdiv double %22, 2.000000e+00
  store double %23, ptr %8, align 8
  %24 = load double, ptr %5, align 8
  %25 = load double, ptr %8, align 8
  %26 = fdiv double %24, %25
  %27 = load double, ptr %8, align 8
  %28 = fcmp olt double %26, %27
  br i1 %28, label %29, label %35

29:                                               ; preds = %18
  %30 = load double, ptr %5, align 8
  %31 = load double, ptr %7, align 8
  %32 = load double, ptr %8, align 8
  %33 = fsub double %32, 1.000000e+00
  %34 = call double @sqrt_impl(double noundef %30, double noundef %31, double noundef %33)
  store double %34, ptr %4, align 8
  br label %40

35:                                               ; preds = %18
  %36 = load double, ptr %5, align 8
  %37 = load double, ptr %8, align 8
  %38 = load double, ptr %6, align 8
  %39 = call double @sqrt_impl(double noundef %36, double noundef %37, double noundef %38)
  store double %39, ptr %4, align 8
  br label %40

40:                                               ; preds = %35, %29, %16
  %41 = load double, ptr %4, align 8
  ret double %41
}

; Function Attrs: noinline nounwind ssp willreturn memory(none) uwtable
define double @sqrt(double noundef %0) #1 {
  %2 = alloca double, align 8
  store double %0, ptr %2, align 8
  %3 = load double, ptr %2, align 8
  %4 = load double, ptr %2, align 8
  %5 = fdiv double %4, 2.000000e+00
  %6 = fadd double %5, 1.000000e+00
  %7 = call double @sqrt_impl(double noundef %3, double noundef 0.000000e+00, double noundef %6)
  ret double %7
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  store i32 0, ptr %1, align 4
  store double 2.000000e-01, ptr %2, align 8
  %4 = call double @llvm.sqrt.f64(double 5.000000e+00)
  %5 = fdiv double 1.000000e+00, %4
  %6 = call double @llvm.sqrt.f64(double 5.000000e+00)
  %7 = fdiv double %5, %6
  store double %7, ptr %3, align 8
  %8 = load double, ptr %3, align 8
  %9 = fsub double %8, 1.000000e+00
  %10 = bitcast double %9 to i64
  %11 = and i64 %10, 9223372036854775807
  %12 = bitcast i64 %11 to double
  %13 = fcmp olt double %12, 0x3CB0000000000000
  br i1 %13, label %14, label %24

14:                                               ; preds = %0
  %15 = load double, ptr %2, align 8
  %16 = load double, ptr %3, align 8
  %17 = fsub double %15, %16
  %18 = bitcast double %17 to i64
  %19 = and i64 %18, 9223372036854775807
  %20 = bitcast i64 %19 to double
  %21 = fcmp olt double %20, 0x3CB0000000000000
  %22 = zext i1 %21 to i64
  %23 = select i1 %21, i32 1, i32 0
  store i32 %23, ptr %1, align 4
  br label %34

24:                                               ; preds = %0
  %25 = load double, ptr %2, align 8
  %26 = load double, ptr %3, align 8
  %27 = fsub double %25, %26
  %28 = bitcast double %27 to i64
  %29 = and i64 %28, 9223372036854775807
  %30 = bitcast i64 %29 to double
  %31 = fcmp olt double %30, 0x3CB0000000000000
  %32 = zext i1 %31 to i64
  %33 = select i1 %31, i32 0, i32 1
  store i32 %33, ptr %1, align 4
  br label %34

34:                                               ; preds = %24, %14
  %35 = load i32, ptr %1, align 4
  ret i32 %35
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline nounwind ssp willreturn memory(none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 5]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Homebrew clang version 21.1.4"}
