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