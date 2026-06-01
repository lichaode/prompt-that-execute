; conflict.lisp
; 可执行提示词：矛盾检测演示
;
; 用途：展示 requires 和 prevents 冲突时解释器的行为
; 验证：python interpreter.py（会报 FAILED ✗）
; ─────────────────────────────────────────────────────────

(diagnose chronic-insomnia

  ; === 知识层：故意写了矛盾，演示检测机制 ===
  (requires  adequate-sleep-opportunity)   ; 必须有充足睡眠条件
  (prevents  adequate-sleep-opportunity)   ; ← 和上一行冲突！
  (requires  duration-3-months)

  ; === 输入层 ===
  (input
    (symptoms  "入睡困难，持续三个月以上")
    (query     "是否符合慢性失眠诊断标准"))

  ; === 输出契约 ===
  (output-contract
    (format          s-expression)
    (must-address    requires-nodes)
    (leaf-strings    allowed)))

; 预期结果：
; ✗ 冲突: requires(adequate-sleep-opportunity)
;         ↔ prevents(adequate-sleep-opportunity)
; → 验证失败 FAILED ✗