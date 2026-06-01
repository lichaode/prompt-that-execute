; geometry.lisp
; 可执行提示词：欧氏几何证明题
;
; 用法：将整个文件粘贴给 LLM，在 input 节点确认已知条件
; 验证：python interpreter.py geometry.lisp
; ─────────────────────────────────────────────────────────

(build-problem similar-triangles

  ; === 知识层：已知条件与证明目标 ===
  (given  (triangle A B C))
  (given  (point D on AB))
  (given  (point E on AC))
  (given  (parallel DE BC))
  (given  (altitude AM BC))
  (given  (intersect AM DE N))
  (given  (ratio AD AB 2/3))
  (prove  (ratio DE BC 2/3))
  (prove  (ratio AN AM 2/3))

  ; === 输入层：确认题目变量（如需修改条件在此替换）===
  (input
    (triangle-vertices  "A B C")
    (ratio-value        "2/3")   ; 修改此处可生成不同难度的变体
    (query              "证明上述两个比例关系"))

  ; === 输出契约：合法输出的形状 ===
  (output-contract
    (format             s-expression)
    (must-address       prove-nodes)
    (proof-style        step-by-step)
    (must-include       intermediate-conclusions)
    (must-include       theorem-citations)
    (leaf-strings       allowed)))
