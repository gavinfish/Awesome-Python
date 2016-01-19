#int get_sign(int x){
#  int r = x+10;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !131
  %3 = add nsw i32 %2, 10, !dbg !131
  store i32 %3, i32* %r, align 4, !dbg !131
  %4 = load i32* %r, align 4, !dbg !132
  ret i32 %4, !dbg !132
}


#int get_sign(int x){
#  int r = x-12;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !131
  %3 = sub nsw i32 %2, 12, !dbg !131
  store i32 %3, i32* %r, align 4, !dbg !131
  %4 = load i32* %r, align 4, !dbg !132
  ret i32 %4, !dbg !132
}


#int get_sign(int x){
#  int r = x*123333333333;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !131
  %3 = sext i32 %2 to i64, !dbg !131
  %4 = mul nsw i64 %3, 123333333333, !dbg !131
  %5 = trunc i64 %4 to i32, !dbg !131
  store i32 %5, i32* %r, align 4, !dbg !131
  %6 = load i32* %r, align 4, !dbg !132
  ret i32 %6, !dbg !132
}


# int get_sign(int x) {
#  int r = x/12;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !123
  %int_cast_to_i64 = zext i32 12 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i64), !dbg !123
  %3 = sdiv i32 %2, 12, !dbg !123
  store i32 %3, i32* %r, align 4, !dbg !123
  %4 = load i32* %r, align 4, !dbg !124
  ret i32 %4, !dbg !124
}


#int get_sign(int x){
#  int r = x+23*x;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !131
  %3 = load i32* %1, align 4, !dbg !131
  %4 = mul nsw i32 23, %3, !dbg !131
  %5 = add nsw i32 %2, %4, !dbg !131
  store i32 %5, i32* %r, align 4, !dbg !131
  %6 = load i32* %r, align 4, !dbg !132
  ret i32 %6, !dbg !132
}


#int get_sign(int x){
#  int r = (x+23)*x;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !131
  %3 = add nsw i32 %2, 23, !dbg !131
  %4 = load i32* %1, align 4, !dbg !131
  %5 = mul nsw i32 %3, %4, !dbg !131
  store i32 %5, i32* %r, align 4, !dbg !131
  %6 = load i32* %r, align 4, !dbg !132
  ret i32 %6, !dbg !132
}


#int get_sign(int x){
#  int r = x*2;
#  if(r<0){
#    r = r+3;
#  }
#  else{
#    r = r-3;
#  }
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !131
  %3 = mul nsw i32 %2, 2, !dbg !131
  store i32 %3, i32* %r, align 4, !dbg !131
  %4 = load i32* %r, align 4, !dbg !132
  %5 = icmp slt i32 %4, 0, !dbg !132
  %6 = load i32* %r, align 4, !dbg !134
  br i1 %5, label %7, label %9, !dbg !132

; <label>:7                                       ; preds = %0
  %8 = add nsw i32 %6, 3, !dbg !134
  store i32 %8, i32* %r, align 4, !dbg !134
  br label %11, !dbg !136

; <label>:9                                       ; preds = %0
  %10 = sub nsw i32 %6, 3, !dbg !137
  store i32 %10, i32* %r, align 4, !dbg !137
  br label %11

; <label>:11                                      ; preds = %9, %7
  %12 = load i32* %r, align 4, !dbg !139
  ret i32 %12, !dbg !139
}


# int get_sign(int x){
#   int r = x*2;
#   if(r<0){
#     r = r+3;
#   }
#   else if(r>0){
#     r = r-3;
#   }
#   else{
#     r = r*10;
#   }
#   return r;
# }
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !123
  %3 = mul nsw i32 %2, 2, !dbg !123
  store i32 %3, i32* %r, align 4, !dbg !123
  %4 = load i32* %r, align 4, !dbg !124
  %5 = icmp slt i32 %4, 0, !dbg !124
  %6 = load i32* %r, align 4, !dbg !126
  br i1 %5, label %7, label %9, !dbg !124

; <label>:7                                       ; preds = %0
  %8 = add nsw i32 %6, 3, !dbg !126
  store i32 %8, i32* %r, align 4, !dbg !126
  br label %16, !dbg !128

; <label>:9                                       ; preds = %0
  %10 = icmp sgt i32 %6, 0, !dbg !129
  %11 = load i32* %r, align 4, !dbg !131
  br i1 %10, label %12, label %14, !dbg !129

; <label>:12                                      ; preds = %9
  %13 = sub nsw i32 %11, 3, !dbg !131
  store i32 %13, i32* %r, align 4, !dbg !131
  br label %16, !dbg !133

; <label>:14                                      ; preds = %9
  %15 = mul nsw i32 %11, 10, !dbg !134
  store i32 %15, i32* %r, align 4, !dbg !134
  br label %16

; <label>:16                                      ; preds = %12, %14, %7
  %17 = load i32* %r, align 4, !dbg !136
  ret i32 %17, !dbg !136
}


# int get_sign(int x, int z){
#   int r = x*2;
#   if(r>=0){
#     r = r-z;
#   }
#   else{
#     r = r+z;
#   }
#   return r;
# }
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x, i32 %z) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  store i32 %z, i32* %2, align 4
  %3 = load i32* %1, align 4, !dbg !123
  %4 = mul nsw i32 %3, 2, !dbg !123
  store i32 %4, i32* %r, align 4, !dbg !123
  %5 = load i32* %r, align 4, !dbg !124
  %6 = icmp sge i32 %5, 0, !dbg !124
  %7 = load i32* %r, align 4, !dbg !126
  %8 = load i32* %2, align 4, !dbg !126
  br i1 %6, label %9, label %11, !dbg !124

; <label>:9                                       ; preds = %0
  %10 = sub nsw i32 %7, %8, !dbg !126
  store i32 %10, i32* %r, align 4, !dbg !126
  br label %13, !dbg !128

; <label>:11                                      ; preds = %0
  %12 = add nsw i32 %7, %8, !dbg !129
  store i32 %12, i32* %r, align 4, !dbg !129
  br label %13

; <label>:13                                      ; preds = %11, %9
  %14 = load i32* %r, align 4, !dbg !131
  ret i32 %14, !dbg !131
}


#int get_sign(int x){
#  int r = x>>5;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !123
  %int_cast_to_i64 = zext i32 5 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i64), !dbg !123
  %3 = ashr i32 %2, 5, !dbg !123
  store i32 %3, i32* %r, align 4, !dbg !123
  %4 = load i32* %r, align 4, !dbg !124
  ret i32 %4, !dbg !124
}


#int get_sign(int x){
#  int r = x+9;
#  if(x<10){
#    r=<<3;
#  }
#  r = r*8;
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !123
  %3 = add nsw i32 %2, 9, !dbg !123
  store i32 %3, i32* %r, align 4, !dbg !123
  %4 = load i32* %1, align 4, !dbg !124
  %5 = icmp slt i32 %4, 10, !dbg !124
  br i1 %5, label %6, label %9, !dbg !124

; <label>:6                                       ; preds = %0
  %7 = load i32* %r, align 4, !dbg !126
  %int_cast_to_i64 = zext i32 3 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i64), !dbg !126
  %8 = shl i32 %7, 3, !dbg !126
  store i32 %8, i32* %r, align 4, !dbg !126
  br label %9, !dbg !128

; <label>:9                                       ; preds = %6, %0
  %10 = load i32* %r, align 4, !dbg !129
  %11 = mul nsw i32 %10, 8, !dbg !129
  store i32 %11, i32* %r, align 4, !dbg !129
  %12 = load i32* %r, align 4, !dbg !130
  ret i32 %12, !dbg !130
}


#int get_sign(int x){
#  int r = 0;
#  for(int i=0;i<10;++i){
#    r+=i;
#  }
#  return r;
#}
; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  store i32 0, i32* %r, align 4, !dbg !123
  store i32 0, i32* %i, align 4, !dbg !124
  br label %2, !dbg !124

; <label>:2                                       ; preds = %5, %0
  %3 = load i32* %i, align 4, !dbg !124
  %4 = icmp slt i32 %3, 10, !dbg !124
  br i1 %4, label %5, label %11, !dbg !124

; <label>:5                                       ; preds = %2
  %6 = load i32* %i, align 4, !dbg !126
  %7 = load i32* %r, align 4, !dbg !126
  %8 = add nsw i32 %7, %6, !dbg !126
  store i32 %8, i32* %r, align 4, !dbg !126
  %9 = load i32* %i, align 4, !dbg !124
  %10 = add nsw i32 %9, 1, !dbg !124
  store i32 %10, i32* %i, align 4, !dbg !124
  br label %2, !dbg !124

; <label>:11                                      ; preds = %2
  %12 = load i32* %r, align 4, !dbg !128
  ret i32 %12, !dbg !128
}
