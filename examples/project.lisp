; project.lisp
; 可执行提示词：项目立项评审
;
; 用法：将整个文件粘贴给 LLM，在 input 节点填入项目摘要
; 验证：python interpreter.py project.lisp
; ─────────────────────────────────────────────────────────

(review-proposal project-alpha

  ; === 知识层：评审规则与约束 ===
  (requires  budget-within-limit)
  (requires  timeline-has-milestones)
  (requires  team-fully-staffed)
  (requires  risks-identified)
  (prevents  budget-exceeds-limit)
  (prevents  unresolved-dependencies)
  (flag      novel-technology)
  (flag      single-point-of-failure)

  ; === 输入层：填入项目数据 ===
  (input
    (budget            "")   ; 例：180万，限额200万
    (timeline          "")   ; 例：Q1/Q2/Q3 里程碑已定义
    (team              "")   ; 例：核心岗位全部到位
    (risks             "")   ; 例：已列出技术风险和市场风险
    (dependencies      "")   ; 例：依赖 project-beta API，尚未完成
    (query             "是否批准立项"))

  ; === 输出契约：合法输出的形状 ===
  (output-contract
    (format            s-expression)
    (must-address      prevents-nodes)
    (must-address      flag-nodes)
    (verdict-required  approve/reject/revise)
    (leaf-strings      allowed)))
