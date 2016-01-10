; ModuleID = 'example.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str1 = private unnamed_addr constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str12 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str2 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1
@.str3 = private unnamed_addr constant [8 x i8] c"IGNORED\00", align 1
@.str14 = private unnamed_addr constant [16 x i8] c"overshift error\00", align 1
@.str25 = private unnamed_addr constant [14 x i8] c"overshift.err\00", align 1
@.str6 = private unnamed_addr constant [13 x i8] c"klee_range.c\00", align 1
@.str17 = private unnamed_addr constant [14 x i8] c"invalid range\00", align 1
@.str28 = private unnamed_addr constant [5 x i8] c"user\00", align 1

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

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 0, i32* %1
  %2 = call i32 (i32*, i64, i8*, ...)* bitcast (i32 (...)* @klee_make_symbolic to i32 (i32*, i64, i8*, ...)*)(i32* %a, i64 4, i8* getelementptr inbounds ([2 x i8]* @.str, i32 0, i32 0)), !dbg !133
  %3 = load i32* %a, align 4, !dbg !134
  %4 = call i32 @get_sign(i32 %3), !dbg !134
  ret i32 %4, !dbg !134
}

declare i32 @klee_make_symbolic(...) #2

; Function Attrs: nounwind ssp uwtable
define void @klee_div_zero_check(i64 %z) #3 {
  %1 = icmp eq i64 %z, 0, !dbg !135
  br i1 %1, label %2, label %3, !dbg !135

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str1, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str12, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8]* @.str2, i64 0, i64 0)) #6, !dbg !137
  unreachable, !dbg !137

; <label>:3                                       ; preds = %0
  ret void, !dbg !138
}

; Function Attrs: noreturn
declare void @klee_report_error(i8*, i32, i8*, i8*) #4

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata) #1

; Function Attrs: nounwind ssp uwtable
define i32 @klee_int(i8* %name) #3 {
  %x = alloca i32, align 4
  %1 = bitcast i32* %x to i8*, !dbg !139
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %1, i64 4, i8* %name) #7, !dbg !139
  %2 = load i32* %x, align 4, !dbg !140, !tbaa !141
  ret i32 %2, !dbg !140
}

; Function Attrs: nounwind ssp uwtable
define void @klee_overshift_check(i64 %bitWidth, i64 %shift) #3 {
  %1 = icmp ult i64 %shift, %bitWidth, !dbg !145
  br i1 %1, label %3, label %2, !dbg !145

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str3, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str14, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str25, i64 0, i64 0)) #6, !dbg !147
  unreachable, !dbg !147

; <label>:3                                       ; preds = %0
  ret void, !dbg !149
}

; Function Attrs: nounwind ssp uwtable
define i32 @klee_range(i32 %start, i32 %end, i8* %name) #3 {
  %x = alloca i32, align 4
  %1 = icmp slt i32 %start, %end, !dbg !150
  br i1 %1, label %3, label %2, !dbg !150

; <label>:2                                       ; preds = %0
  call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str6, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str28, i64 0, i64 0)) #6, !dbg !152
  unreachable, !dbg !152

; <label>:3                                       ; preds = %0
  %4 = add nsw i32 %start, 1, !dbg !153
  %5 = icmp eq i32 %4, %end, !dbg !153
  br i1 %5, label %21, label %6, !dbg !153

; <label>:6                                       ; preds = %3
  %7 = bitcast i32* %x to i8*, !dbg !155
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %7, i64 4, i8* %name) #7, !dbg !155
  %8 = icmp eq i32 %start, 0, !dbg !157
  %9 = load i32* %x, align 4, !dbg !159, !tbaa !141
  br i1 %8, label %10, label %13, !dbg !157

; <label>:10                                      ; preds = %6
  %11 = icmp ult i32 %9, %end, !dbg !159
  %12 = zext i1 %11 to i64, !dbg !159
  call void @klee_assume(i64 %12) #7, !dbg !159
  br label %19, !dbg !161

; <label>:13                                      ; preds = %6
  %14 = icmp sge i32 %9, %start, !dbg !162
  %15 = zext i1 %14 to i64, !dbg !162
  call void @klee_assume(i64 %15) #7, !dbg !162
  %16 = load i32* %x, align 4, !dbg !164, !tbaa !141
  %17 = icmp slt i32 %16, %end, !dbg !164
  %18 = zext i1 %17 to i64, !dbg !164
  call void @klee_assume(i64 %18) #7, !dbg !164
  br label %19

; <label>:19                                      ; preds = %13, %10
  %20 = load i32* %x, align 4, !dbg !165, !tbaa !141
  br label %21, !dbg !165

; <label>:21                                      ; preds = %19, %3
  %.0 = phi i32 [ %20, %19 ], [ %start, %3 ]
  ret i32 %.0, !dbg !166
}

declare void @klee_assume(i64) #5

; Function Attrs: nounwind ssp uwtable
define weak i8* @memcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #3 {
  %1 = icmp eq i64 %len, 0, !dbg !167
  br i1 %1, label %._crit_edge, label %.lr.ph.preheader, !dbg !167

.lr.ph.preheader:                                 ; preds = %0
  %n.vec = and i64 %len, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %2 = add i64 %len, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %.lr.ph.preheader
  %scevgep4 = getelementptr i8* %srcaddr, i64 %2
  %scevgep = getelementptr i8* %destaddr, i64 %2
  %bound1 = icmp uge i8* %scevgep, %srcaddr
  %bound0 = icmp uge i8* %scevgep4, %destaddr
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %srcaddr, i64 %n.vec
  %ptr.ind.end6 = getelementptr i8* %destaddr, i64 %n.vec
  %rev.ind.end = sub i64 %len, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.memcheck
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.memcheck ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep103 = getelementptr i8* %destaddr, i64 %index
  %3 = bitcast i8* %next.gep to <16 x i8>*, !dbg !168
  %wide.load = load <16 x i8>* %3, align 1, !dbg !168
  %next.gep.sum279 = or i64 %index, 16, !dbg !168
  %4 = getelementptr i8* %srcaddr, i64 %next.gep.sum279, !dbg !168
  %5 = bitcast i8* %4 to <16 x i8>*, !dbg !168
  %wide.load200 = load <16 x i8>* %5, align 1, !dbg !168
  %6 = bitcast i8* %next.gep103 to <16 x i8>*, !dbg !168
  store <16 x i8> %wide.load, <16 x i8>* %6, align 1, !dbg !168
  %7 = getelementptr i8* %destaddr, i64 %next.gep.sum279, !dbg !168
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !168
  store <16 x i8> %wide.load200, <16 x i8>* %8, align 1, !dbg !168
  %index.next = add i64 %index, 32
  %9 = icmp eq i64 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !169

middle.block:                                     ; preds = %vector.body, %vector.memcheck, %.lr.ph.preheader
  %resume.val = phi i8* [ %srcaddr, %.lr.ph.preheader ], [ %srcaddr, %vector.memcheck ], [ %ptr.ind.end, %vector.body ]
  %resume.val5 = phi i8* [ %destaddr, %.lr.ph.preheader ], [ %destaddr, %vector.memcheck ], [ %ptr.ind.end6, %vector.body ]
  %resume.val7 = phi i64 [ %len, %.lr.ph.preheader ], [ %len, %vector.memcheck ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %.lr.ph.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %len
  br i1 %cmp.n, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph, %middle.block
  %src.03 = phi i8* [ %11, %.lr.ph ], [ %resume.val, %middle.block ]
  %dest.02 = phi i8* [ %13, %.lr.ph ], [ %resume.val5, %middle.block ]
  %.01 = phi i64 [ %10, %.lr.ph ], [ %resume.val7, %middle.block ]
  %10 = add i64 %.01, -1, !dbg !167
  %11 = getelementptr inbounds i8* %src.03, i64 1, !dbg !168
  %12 = load i8* %src.03, align 1, !dbg !168, !tbaa !172
  %13 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !168
  store i8 %12, i8* %dest.02, align 1, !dbg !168, !tbaa !172
  %14 = icmp eq i64 %10, 0, !dbg !167
  br i1 %14, label %._crit_edge, label %.lr.ph, !dbg !167, !llvm.loop !173

._crit_edge:                                      ; preds = %.lr.ph, %middle.block, %0
  ret i8* %destaddr, !dbg !174
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memmove(i8* %dst, i8* %src, i64 %count) #3 {
  %1 = icmp eq i8* %src, %dst, !dbg !175
  br i1 %1, label %.loopexit, label %2, !dbg !175

; <label>:2                                       ; preds = %0
  %3 = icmp ugt i8* %src, %dst, !dbg !177
  br i1 %3, label %.preheader, label %18, !dbg !177

.preheader:                                       ; preds = %2
  %4 = icmp eq i64 %count, 0, !dbg !179
  br i1 %4, label %.loopexit, label %.lr.ph.preheader, !dbg !179

.lr.ph.preheader:                                 ; preds = %.preheader
  %n.vec = and i64 %count, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %5 = add i64 %count, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %.lr.ph.preheader
  %scevgep11 = getelementptr i8* %src, i64 %5
  %scevgep = getelementptr i8* %dst, i64 %5
  %bound1 = icmp uge i8* %scevgep, %src
  %bound0 = icmp uge i8* %scevgep11, %dst
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %src, i64 %n.vec
  %ptr.ind.end13 = getelementptr i8* %dst, i64 %n.vec
  %rev.ind.end = sub i64 %count, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.memcheck
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.memcheck ]
  %next.gep = getelementptr i8* %src, i64 %index
  %next.gep110 = getelementptr i8* %dst, i64 %index
  %6 = bitcast i8* %next.gep to <16 x i8>*, !dbg !179
  %wide.load = load <16 x i8>* %6, align 1, !dbg !179
  %next.gep.sum586 = or i64 %index, 16, !dbg !179
  %7 = getelementptr i8* %src, i64 %next.gep.sum586, !dbg !179
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !179
  %wide.load207 = load <16 x i8>* %8, align 1, !dbg !179
  %9 = bitcast i8* %next.gep110 to <16 x i8>*, !dbg !179
  store <16 x i8> %wide.load, <16 x i8>* %9, align 1, !dbg !179
  %10 = getelementptr i8* %dst, i64 %next.gep.sum586, !dbg !179
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !179
  store <16 x i8> %wide.load207, <16 x i8>* %11, align 1, !dbg !179
  %index.next = add i64 %index, 32
  %12 = icmp eq i64 %index.next, %n.vec
  br i1 %12, label %middle.block, label %vector.body, !llvm.loop !181

middle.block:                                     ; preds = %vector.body, %vector.memcheck, %.lr.ph.preheader
  %resume.val = phi i8* [ %src, %.lr.ph.preheader ], [ %src, %vector.memcheck ], [ %ptr.ind.end, %vector.body ]
  %resume.val12 = phi i8* [ %dst, %.lr.ph.preheader ], [ %dst, %vector.memcheck ], [ %ptr.ind.end13, %vector.body ]
  %resume.val14 = phi i64 [ %count, %.lr.ph.preheader ], [ %count, %vector.memcheck ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %.lr.ph.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %count
  br i1 %cmp.n, label %.loopexit, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph, %middle.block
  %b.04 = phi i8* [ %14, %.lr.ph ], [ %resume.val, %middle.block ]
  %a.03 = phi i8* [ %16, %.lr.ph ], [ %resume.val12, %middle.block ]
  %.02 = phi i64 [ %13, %.lr.ph ], [ %resume.val14, %middle.block ]
  %13 = add i64 %.02, -1, !dbg !179
  %14 = getelementptr inbounds i8* %b.04, i64 1, !dbg !179
  %15 = load i8* %b.04, align 1, !dbg !179, !tbaa !172
  %16 = getelementptr inbounds i8* %a.03, i64 1, !dbg !179
  store i8 %15, i8* %a.03, align 1, !dbg !179, !tbaa !172
  %17 = icmp eq i64 %13, 0, !dbg !179
  br i1 %17, label %.loopexit, label %.lr.ph, !dbg !179, !llvm.loop !182

; <label>:18                                      ; preds = %2
  %19 = add i64 %count, -1, !dbg !183
  %20 = icmp eq i64 %count, 0, !dbg !185
  br i1 %20, label %.loopexit, label %.lr.ph9, !dbg !185

.lr.ph9:                                          ; preds = %18
  %21 = getelementptr inbounds i8* %src, i64 %19, !dbg !186
  %22 = getelementptr inbounds i8* %dst, i64 %19, !dbg !183
  %n.vec215 = and i64 %count, -32
  %cmp.zero217 = icmp eq i64 %n.vec215, 0
  br i1 %cmp.zero217, label %middle.block210, label %vector.memcheck224

vector.memcheck224:                               ; preds = %.lr.ph9
  %bound1221 = icmp ule i8* %21, %dst
  %bound0220 = icmp ule i8* %22, %src
  %memcheck.conflict223 = and i1 %bound0220, %bound1221
  %.sum = sub i64 %19, %n.vec215
  %rev.ptr.ind.end = getelementptr i8* %src, i64 %.sum
  %rev.ptr.ind.end229 = getelementptr i8* %dst, i64 %.sum
  %rev.ind.end231 = sub i64 %count, %n.vec215
  br i1 %memcheck.conflict223, label %middle.block210, label %vector.body209

vector.body209:                                   ; preds = %vector.body209, %vector.memcheck224
  %index212 = phi i64 [ %index.next234, %vector.body209 ], [ 0, %vector.memcheck224 ]
  %.sum440 = sub i64 %19, %index212
  %next.gep236.sum = add i64 %.sum440, -15, !dbg !185
  %23 = getelementptr i8* %src, i64 %next.gep236.sum, !dbg !185
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !185
  %wide.load434 = load <16 x i8>* %24, align 1, !dbg !185
  %reverse = shufflevector <16 x i8> %wide.load434, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !185
  %.sum505 = add i64 %.sum440, -31, !dbg !185
  %25 = getelementptr i8* %src, i64 %.sum505, !dbg !185
  %26 = bitcast i8* %25 to <16 x i8>*, !dbg !185
  %wide.load435 = load <16 x i8>* %26, align 1, !dbg !185
  %reverse436 = shufflevector <16 x i8> %wide.load435, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !185
  %reverse437 = shufflevector <16 x i8> %reverse, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !185
  %27 = getelementptr i8* %dst, i64 %next.gep236.sum, !dbg !185
  %28 = bitcast i8* %27 to <16 x i8>*, !dbg !185
  store <16 x i8> %reverse437, <16 x i8>* %28, align 1, !dbg !185
  %reverse438 = shufflevector <16 x i8> %reverse436, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !185
  %29 = getelementptr i8* %dst, i64 %.sum505, !dbg !185
  %30 = bitcast i8* %29 to <16 x i8>*, !dbg !185
  store <16 x i8> %reverse438, <16 x i8>* %30, align 1, !dbg !185
  %index.next234 = add i64 %index212, 32
  %31 = icmp eq i64 %index.next234, %n.vec215
  br i1 %31, label %middle.block210, label %vector.body209, !llvm.loop !187

middle.block210:                                  ; preds = %vector.body209, %vector.memcheck224, %.lr.ph9
  %resume.val225 = phi i8* [ %21, %.lr.ph9 ], [ %21, %vector.memcheck224 ], [ %rev.ptr.ind.end, %vector.body209 ]
  %resume.val227 = phi i8* [ %22, %.lr.ph9 ], [ %22, %vector.memcheck224 ], [ %rev.ptr.ind.end229, %vector.body209 ]
  %resume.val230 = phi i64 [ %count, %.lr.ph9 ], [ %count, %vector.memcheck224 ], [ %rev.ind.end231, %vector.body209 ]
  %new.indc.resume.val232 = phi i64 [ 0, %.lr.ph9 ], [ 0, %vector.memcheck224 ], [ %n.vec215, %vector.body209 ]
  %cmp.n233 = icmp eq i64 %new.indc.resume.val232, %count
  br i1 %cmp.n233, label %.loopexit, label %scalar.ph211

scalar.ph211:                                     ; preds = %scalar.ph211, %middle.block210
  %b.18 = phi i8* [ %33, %scalar.ph211 ], [ %resume.val225, %middle.block210 ]
  %a.17 = phi i8* [ %35, %scalar.ph211 ], [ %resume.val227, %middle.block210 ]
  %.16 = phi i64 [ %32, %scalar.ph211 ], [ %resume.val230, %middle.block210 ]
  %32 = add i64 %.16, -1, !dbg !185
  %33 = getelementptr inbounds i8* %b.18, i64 -1, !dbg !185
  %34 = load i8* %b.18, align 1, !dbg !185, !tbaa !172
  %35 = getelementptr inbounds i8* %a.17, i64 -1, !dbg !185
  store i8 %34, i8* %a.17, align 1, !dbg !185, !tbaa !172
  %36 = icmp eq i64 %32, 0, !dbg !185
  br i1 %36, label %.loopexit, label %scalar.ph211, !dbg !185, !llvm.loop !188

.loopexit:                                        ; preds = %scalar.ph211, %middle.block210, %18, %.lr.ph, %middle.block, %.preheader, %0
  ret i8* %dst, !dbg !189
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @mempcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #3 {
  %1 = icmp eq i64 %len, 0, !dbg !190
  br i1 %1, label %15, label %.lr.ph.preheader, !dbg !190

.lr.ph.preheader:                                 ; preds = %0
  %n.vec = and i64 %len, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %2 = add i64 %len, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %.lr.ph.preheader
  %scevgep5 = getelementptr i8* %srcaddr, i64 %2
  %scevgep4 = getelementptr i8* %destaddr, i64 %2
  %bound1 = icmp uge i8* %scevgep4, %srcaddr
  %bound0 = icmp uge i8* %scevgep5, %destaddr
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %srcaddr, i64 %n.vec
  %ptr.ind.end7 = getelementptr i8* %destaddr, i64 %n.vec
  %rev.ind.end = sub i64 %len, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.memcheck
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.memcheck ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep104 = getelementptr i8* %destaddr, i64 %index
  %3 = bitcast i8* %next.gep to <16 x i8>*, !dbg !191
  %wide.load = load <16 x i8>* %3, align 1, !dbg !191
  %next.gep.sum280 = or i64 %index, 16, !dbg !191
  %4 = getelementptr i8* %srcaddr, i64 %next.gep.sum280, !dbg !191
  %5 = bitcast i8* %4 to <16 x i8>*, !dbg !191
  %wide.load201 = load <16 x i8>* %5, align 1, !dbg !191
  %6 = bitcast i8* %next.gep104 to <16 x i8>*, !dbg !191
  store <16 x i8> %wide.load, <16 x i8>* %6, align 1, !dbg !191
  %7 = getelementptr i8* %destaddr, i64 %next.gep.sum280, !dbg !191
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !191
  store <16 x i8> %wide.load201, <16 x i8>* %8, align 1, !dbg !191
  %index.next = add i64 %index, 32
  %9 = icmp eq i64 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !192

middle.block:                                     ; preds = %vector.body, %vector.memcheck, %.lr.ph.preheader
  %resume.val = phi i8* [ %srcaddr, %.lr.ph.preheader ], [ %srcaddr, %vector.memcheck ], [ %ptr.ind.end, %vector.body ]
  %resume.val6 = phi i8* [ %destaddr, %.lr.ph.preheader ], [ %destaddr, %vector.memcheck ], [ %ptr.ind.end7, %vector.body ]
  %resume.val8 = phi i64 [ %len, %.lr.ph.preheader ], [ %len, %vector.memcheck ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %.lr.ph.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %len
  br i1 %cmp.n, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph, %middle.block
  %src.03 = phi i8* [ %11, %.lr.ph ], [ %resume.val, %middle.block ]
  %dest.02 = phi i8* [ %13, %.lr.ph ], [ %resume.val6, %middle.block ]
  %.01 = phi i64 [ %10, %.lr.ph ], [ %resume.val8, %middle.block ]
  %10 = add i64 %.01, -1, !dbg !190
  %11 = getelementptr inbounds i8* %src.03, i64 1, !dbg !191
  %12 = load i8* %src.03, align 1, !dbg !191, !tbaa !172
  %13 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !191
  store i8 %12, i8* %dest.02, align 1, !dbg !191, !tbaa !172
  %14 = icmp eq i64 %10, 0, !dbg !190
  br i1 %14, label %._crit_edge, label %.lr.ph, !dbg !190, !llvm.loop !193

._crit_edge:                                      ; preds = %.lr.ph, %middle.block
  %scevgep = getelementptr i8* %destaddr, i64 %len
  br label %15, !dbg !190

; <label>:15                                      ; preds = %._crit_edge, %0
  %dest.0.lcssa = phi i8* [ %scevgep, %._crit_edge ], [ %destaddr, %0 ]
  ret i8* %dest.0.lcssa, !dbg !194
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memset(i8* %dst, i32 %s, i64 %count) #3 {
  %1 = icmp eq i64 %count, 0, !dbg !195
  br i1 %1, label %._crit_edge, label %.lr.ph, !dbg !195

.lr.ph:                                           ; preds = %0
  %2 = trunc i32 %s to i8, !dbg !196
  br label %3, !dbg !195

; <label>:3                                       ; preds = %3, %.lr.ph
  %a.02 = phi i8* [ %dst, %.lr.ph ], [ %5, %3 ]
  %.01 = phi i64 [ %count, %.lr.ph ], [ %4, %3 ]
  %4 = add i64 %.01, -1, !dbg !195
  %5 = getelementptr inbounds i8* %a.02, i64 1, !dbg !196
  store volatile i8 %2, i8* %a.02, align 1, !dbg !196, !tbaa !172
  %6 = icmp eq i64 %4, 0, !dbg !195
  br i1 %6, label %._crit_edge, label %3, !dbg !195

._crit_edge:                                      ; preds = %3, %0
  ret i8* %dst, !dbg !197
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nobuiltin noreturn nounwind }
attributes #7 = { nobuiltin nounwind }

!llvm.dbg.cu = !{!0, !12, !23, !37, !49, !62, !82, !97, !112}
!llvm.module.flags = !{!128, !129}
!llvm.ident = !{!130, !130, !130, !130, !130, !130, !130, !130, !130}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG
!1 = metadata !{metadata !"example.c", metadata !"/home/fish/test"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !9}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"get_sign", metadata !"get_sign", metadata !"", i32 1, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32)* @get_sign, null, null, metadata !2, i32 1} ; [ DW_TAG
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/fish/test/example.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 7, metadata !10, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @main, null, null, metadata !2, i32 7} ; [ DW_TAG_subprogram ] [l
!10 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !11, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!11 = metadata !{metadata !8}
!12 = metadata !{i32 786449, metadata !13, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !14, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!13 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/klee_div_zero_check.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!14 = metadata !{metadata !15}
!15 = metadata !{i32 786478, metadata !16, metadata !17, metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !"", i32 12, metadata !18, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64)* @klee_div_zero_check, null
!16 = metadata !{metadata !"klee_div_zero_check.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!17 = metadata !{i32 786473, metadata !16}        ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/klee_div_zero_check.c]
!18 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !19, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!19 = metadata !{null, metadata !20}
!20 = metadata !{i32 786468, null, null, metadata !"long long int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long long int] [line 0, size 64, align 64, offset 0, enc DW_ATE_signed]
!21 = metadata !{metadata !22}
!22 = metadata !{i32 786689, metadata !15, metadata !"z", metadata !17, i32 16777228, metadata !20, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [z] [line 12]
!23 = metadata !{i32 786449, metadata !24, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !25, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!24 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/klee_int.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!25 = metadata !{metadata !26}
!26 = metadata !{i32 786478, metadata !27, metadata !28, metadata !"klee_int", metadata !"klee_int", metadata !"", i32 13, metadata !29, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @klee_int, null, null, metadata !34, i32 13} ; [ 
!27 = metadata !{metadata !"klee_int.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!28 = metadata !{i32 786473, metadata !27}        ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/klee_int.c]
!29 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !30, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!30 = metadata !{metadata !8, metadata !31}
!31 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !32} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!32 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !33} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!33 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!34 = metadata !{metadata !35, metadata !36}
!35 = metadata !{i32 786689, metadata !26, metadata !"name", metadata !28, i32 16777229, metadata !31, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!36 = metadata !{i32 786688, metadata !26, metadata !"x", metadata !28, i32 14, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!37 = metadata !{i32 786449, metadata !38, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !39, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!38 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/klee_overshift_check.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!39 = metadata !{metadata !40}
!40 = metadata !{i32 786478, metadata !41, metadata !42, metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !"", i32 20, metadata !43, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64, i64)* @klee_overshift_che
!41 = metadata !{metadata !"klee_overshift_check.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!42 = metadata !{i32 786473, metadata !41}        ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/klee_overshift_check.c]
!43 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !44, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!44 = metadata !{null, metadata !45, metadata !45}
!45 = metadata !{i32 786468, null, null, metadata !"long long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!46 = metadata !{metadata !47, metadata !48}
!47 = metadata !{i32 786689, metadata !40, metadata !"bitWidth", metadata !42, i32 16777236, metadata !45, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bitWidth] [line 20]
!48 = metadata !{i32 786689, metadata !40, metadata !"shift", metadata !42, i32 33554452, metadata !45, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [shift] [line 20]
!49 = metadata !{i32 786449, metadata !50, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !51, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!50 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/klee_range.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!51 = metadata !{metadata !52}
!52 = metadata !{i32 786478, metadata !53, metadata !54, metadata !"klee_range", metadata !"klee_range", metadata !"", i32 13, metadata !55, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i8*)* @klee_range, null, null, metadata !
!53 = metadata !{metadata !"klee_range.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!54 = metadata !{i32 786473, metadata !53}        ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/klee_range.c]
!55 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !56, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!56 = metadata !{metadata !8, metadata !8, metadata !8, metadata !31}
!57 = metadata !{metadata !58, metadata !59, metadata !60, metadata !61}
!58 = metadata !{i32 786689, metadata !52, metadata !"start", metadata !54, i32 16777229, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [start] [line 13]
!59 = metadata !{i32 786689, metadata !52, metadata !"end", metadata !54, i32 33554445, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [end] [line 13]
!60 = metadata !{i32 786689, metadata !52, metadata !"name", metadata !54, i32 50331661, metadata !31, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!61 = metadata !{i32 786688, metadata !52, metadata !"x", metadata !54, i32 14, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!62 = metadata !{i32 786449, metadata !63, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !64, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!63 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/memcpy.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!64 = metadata !{metadata !65}
!65 = metadata !{i32 786478, metadata !66, metadata !67, metadata !"memcpy", metadata !"memcpy", metadata !"", i32 12, metadata !68, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memcpy, null, null, metadata !75, i32 12} 
!66 = metadata !{metadata !"memcpy.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!67 = metadata !{i32 786473, metadata !66}        ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/memcpy.c]
!68 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !69, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!69 = metadata !{metadata !70, metadata !70, metadata !71, metadata !73}
!70 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!71 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !72} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!72 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!73 = metadata !{i32 786454, metadata !66, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !74} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!74 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!75 = metadata !{metadata !76, metadata !77, metadata !78, metadata !79, metadata !81}
!76 = metadata !{i32 786689, metadata !65, metadata !"destaddr", metadata !67, i32 16777228, metadata !70, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 12]
!77 = metadata !{i32 786689, metadata !65, metadata !"srcaddr", metadata !67, i32 33554444, metadata !71, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 12]
!78 = metadata !{i32 786689, metadata !65, metadata !"len", metadata !67, i32 50331660, metadata !73, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 12]
!79 = metadata !{i32 786688, metadata !65, metadata !"dest", metadata !67, i32 13, metadata !80, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 13]
!80 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !33} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!81 = metadata !{i32 786688, metadata !65, metadata !"src", metadata !67, i32 14, metadata !31, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 14]
!82 = metadata !{i32 786449, metadata !83, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !84, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!83 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/memmove.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!84 = metadata !{metadata !85}
!85 = metadata !{i32 786478, metadata !86, metadata !87, metadata !"memmove", metadata !"memmove", metadata !"", i32 12, metadata !88, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memmove, null, null, metadata !91, i32 1
!86 = metadata !{metadata !"memmove.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!87 = metadata !{i32 786473, metadata !86}        ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/memmove.c]
!88 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !89, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!89 = metadata !{metadata !70, metadata !70, metadata !71, metadata !90}
!90 = metadata !{i32 786454, metadata !86, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !74} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!91 = metadata !{metadata !92, metadata !93, metadata !94, metadata !95, metadata !96}
!92 = metadata !{i32 786689, metadata !85, metadata !"dst", metadata !87, i32 16777228, metadata !70, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 12]
!93 = metadata !{i32 786689, metadata !85, metadata !"src", metadata !87, i32 33554444, metadata !71, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [src] [line 12]
!94 = metadata !{i32 786689, metadata !85, metadata !"count", metadata !87, i32 50331660, metadata !90, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 12]
!95 = metadata !{i32 786688, metadata !85, metadata !"a", metadata !87, i32 13, metadata !80, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 13]
!96 = metadata !{i32 786688, metadata !85, metadata !"b", metadata !87, i32 14, metadata !31, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [b] [line 14]
!97 = metadata !{i32 786449, metadata !98, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !99, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!98 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/mempcpy.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!99 = metadata !{metadata !100}
!100 = metadata !{i32 786478, metadata !101, metadata !102, metadata !"mempcpy", metadata !"mempcpy", metadata !"", i32 11, metadata !103, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @mempcpy, null, null, metadata !106, 
!101 = metadata !{metadata !"mempcpy.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!102 = metadata !{i32 786473, metadata !101}      ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/mempcpy.c]
!103 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !104, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!104 = metadata !{metadata !70, metadata !70, metadata !71, metadata !105}
!105 = metadata !{i32 786454, metadata !101, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !74} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!106 = metadata !{metadata !107, metadata !108, metadata !109, metadata !110, metadata !111}
!107 = metadata !{i32 786689, metadata !100, metadata !"destaddr", metadata !102, i32 16777227, metadata !70, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 11]
!108 = metadata !{i32 786689, metadata !100, metadata !"srcaddr", metadata !102, i32 33554443, metadata !71, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 11]
!109 = metadata !{i32 786689, metadata !100, metadata !"len", metadata !102, i32 50331659, metadata !105, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 11]
!110 = metadata !{i32 786688, metadata !100, metadata !"dest", metadata !102, i32 12, metadata !80, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 12]
!111 = metadata !{i32 786688, metadata !100, metadata !"src", metadata !102, i32 13, metadata !31, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 13]
!112 = metadata !{i32 786449, metadata !113, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !114, metadata !2, metadata !2, metadata !""} ; [ DW
!113 = metadata !{metadata !"/home/fish/klee/runtime/Intrinsic/memset.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!114 = metadata !{metadata !115}
!115 = metadata !{i32 786478, metadata !116, metadata !117, metadata !"memset", metadata !"memset", metadata !"", i32 11, metadata !118, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32, i64)* @memset, null, null, metadata !121, i32
!116 = metadata !{metadata !"memset.c", metadata !"/home/fish/klee/runtime/Intrinsic"}
!117 = metadata !{i32 786473, metadata !116}      ; [ DW_TAG_file_type ] [/home/fish/klee/runtime/Intrinsic/memset.c]
!118 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !119, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!119 = metadata !{metadata !70, metadata !70, metadata !8, metadata !120}
!120 = metadata !{i32 786454, metadata !116, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !74} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!121 = metadata !{metadata !122, metadata !123, metadata !124, metadata !125}
!122 = metadata !{i32 786689, metadata !115, metadata !"dst", metadata !117, i32 16777227, metadata !70, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 11]
!123 = metadata !{i32 786689, metadata !115, metadata !"s", metadata !117, i32 33554443, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [s] [line 11]
!124 = metadata !{i32 786689, metadata !115, metadata !"count", metadata !117, i32 50331659, metadata !120, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 11]
!125 = metadata !{i32 786688, metadata !115, metadata !"a", metadata !117, i32 12, metadata !126, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 12]
!126 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !127} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!127 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !33} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from char]
!128 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!129 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!130 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!131 = metadata !{i32 2, i32 0, metadata !4, null}
!132 = metadata !{i32 3, i32 0, metadata !4, null}
!133 = metadata !{i32 9, i32 0, metadata !9, null}
!134 = metadata !{i32 10, i32 0, metadata !9, null}
!135 = metadata !{i32 13, i32 0, metadata !136, null}
!136 = metadata !{i32 786443, metadata !16, metadata !15, i32 13, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_div_zero_check.c]
!137 = metadata !{i32 14, i32 0, metadata !136, null}
!138 = metadata !{i32 15, i32 0, metadata !15, null}
!139 = metadata !{i32 15, i32 0, metadata !26, null}
!140 = metadata !{i32 16, i32 0, metadata !26, null}
!141 = metadata !{metadata !142, metadata !142, i64 0}
!142 = metadata !{metadata !"int", metadata !143, i64 0}
!143 = metadata !{metadata !"omnipotent char", metadata !144, i64 0}
!144 = metadata !{metadata !"Simple C/C++ TBAA"}
!145 = metadata !{i32 21, i32 0, metadata !146, null}
!146 = metadata !{i32 786443, metadata !41, metadata !40, i32 21, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_overshift_check.c]
!147 = metadata !{i32 27, i32 0, metadata !148, null}
!148 = metadata !{i32 786443, metadata !41, metadata !146, i32 21, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_overshift_check.c]
!149 = metadata !{i32 29, i32 0, metadata !40, null}
!150 = metadata !{i32 16, i32 0, metadata !151, null}
!151 = metadata !{i32 786443, metadata !53, metadata !52, i32 16, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_range.c]
!152 = metadata !{i32 17, i32 0, metadata !151, null}
!153 = metadata !{i32 19, i32 0, metadata !154, null}
!154 = metadata !{i32 786443, metadata !53, metadata !52, i32 19, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_range.c]
!155 = metadata !{i32 22, i32 0, metadata !156, null}
!156 = metadata !{i32 786443, metadata !53, metadata !154, i32 21, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_range.c]
!157 = metadata !{i32 25, i32 0, metadata !158, null}
!158 = metadata !{i32 786443, metadata !53, metadata !156, i32 25, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_range.c]
!159 = metadata !{i32 26, i32 0, metadata !160, null}
!160 = metadata !{i32 786443, metadata !53, metadata !158, i32 25, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_range.c]
!161 = metadata !{i32 27, i32 0, metadata !160, null}
!162 = metadata !{i32 28, i32 0, metadata !163, null}
!163 = metadata !{i32 786443, metadata !53, metadata !158, i32 27, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/klee_range.c]
!164 = metadata !{i32 29, i32 0, metadata !163, null}
!165 = metadata !{i32 32, i32 0, metadata !156, null}
!166 = metadata !{i32 34, i32 0, metadata !52, null}
!167 = metadata !{i32 16, i32 0, metadata !65, null}
!168 = metadata !{i32 17, i32 0, metadata !65, null}
!169 = metadata !{metadata !169, metadata !170, metadata !171}
!170 = metadata !{metadata !"llvm.vectorizer.width", i32 1}
!171 = metadata !{metadata !"llvm.vectorizer.unroll", i32 1}
!172 = metadata !{metadata !143, metadata !143, i64 0}
!173 = metadata !{metadata !173, metadata !170, metadata !171}
!174 = metadata !{i32 18, i32 0, metadata !65, null}
!175 = metadata !{i32 16, i32 0, metadata !176, null}
!176 = metadata !{i32 786443, metadata !86, metadata !85, i32 16, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/memmove.c]
!177 = metadata !{i32 19, i32 0, metadata !178, null}
!178 = metadata !{i32 786443, metadata !86, metadata !85, i32 19, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/memmove.c]
!179 = metadata !{i32 20, i32 0, metadata !180, null}
!180 = metadata !{i32 786443, metadata !86, metadata !178, i32 19, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/memmove.c]
!181 = metadata !{metadata !181, metadata !170, metadata !171}
!182 = metadata !{metadata !182, metadata !170, metadata !171}
!183 = metadata !{i32 22, i32 0, metadata !184, null}
!184 = metadata !{i32 786443, metadata !86, metadata !178, i32 21, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/fish/klee/runtime/Intrinsic/memmove.c]
!185 = metadata !{i32 24, i32 0, metadata !184, null}
!186 = metadata !{i32 23, i32 0, metadata !184, null}
!187 = metadata !{metadata !187, metadata !170, metadata !171}
!188 = metadata !{metadata !188, metadata !170, metadata !171}
!189 = metadata !{i32 28, i32 0, metadata !85, null}
!190 = metadata !{i32 15, i32 0, metadata !100, null}
!191 = metadata !{i32 16, i32 0, metadata !100, null}
!192 = metadata !{metadata !192, metadata !170, metadata !171}
!193 = metadata !{metadata !193, metadata !170, metadata !171}
!194 = metadata !{i32 17, i32 0, metadata !100, null}
!195 = metadata !{i32 13, i32 0, metadata !115, null}
!196 = metadata !{i32 14, i32 0, metadata !115, null}
!197 = metadata !{i32 15, i32 0, metadata !115, null}
