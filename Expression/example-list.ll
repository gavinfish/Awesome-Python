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