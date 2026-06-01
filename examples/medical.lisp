; medical.lisp
; 可执行提示词：链球菌肺炎诊断与治疗
;
; 用法：将整个文件粘贴给 LLM，在 input 节点填入患者数据
; 验证：python interpreter.py medical.lisp
; ─────────────────────────────────────────────────────────

(diagnose streptococcal-pneumonia

  ; === 知识层：诊断规则与约束 ===
  (caused-by      streptococcus-pneumoniae)
  (presents-with  fever)
  (presents-with  productive-cough)
  (requires       antibiotics)
  (first-line     penicillin)
  (contraindicated penicillin penicillin-allergy)

  ; === 输入层：填入患者数据 ===
  (input
    (patient-symptoms  "")   ; 例：发烧39度，咳嗽有痰
    (patient-history   "")   ; 例：有青霉素过敏史
    (query             "如何治疗"))

  ; === 输出契约：合法输出的形状 ===
  (output-contract
    (format           s-expression)
    (must-address     contraindicated-nodes)
    (must-include     treatment-alternative when first-line-blocked)
    (must-include     supportive-care)
    (leaf-strings     allowed)))
