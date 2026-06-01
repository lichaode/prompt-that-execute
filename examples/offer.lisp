; offer.lisp
; 可执行提示词：工作 Offer 评估
;
; 用法：将整个文件粘贴给 LLM，在 input 节点填入 offer 详情
; 验证：python interpreter.py offer.lisp
; ─────────────────────────────────────────────────────────

(evaluate-offer company-A

  ; === 知识层：评估规则与约束 ===
  (requires  salary-meets-expectation)
  (requires  location-acceptable)
  (requires  has-growth-path)
  (prevents  toxic-culture)
  (prevents  excessive-overtime)
  (flag      equity-vesting-cliff)
  (flag      remote-policy-unclear)

  ; === 输入层：填入 offer 数据 ===
  (input
    (salary            "")   ; 例：年薪50万，期望45万以上
    (location          "")   ; 例：上海，可接受
    (growth            "")   ; 例：18个月内有晋升通道
    (culture           "")   ; 例：Glassdoor评分4.1，无异常反馈
    (overtime          "")   ; 例：偶尔加班，无强制要求
    (equity            "")   ; 例：4年归属，1年悬崖
    (remote            "")   ; 例：每周3天远程，合同未写明
    (query             "是否接受这份 offer"))

  ; === 输出契约：合法输出的形状 ===
  (output-contract
    (format            s-expression)
    (must-address      prevents-nodes)
    (must-address      flag-nodes)
    (verdict-required  accept/reject/negotiate)
    (must-include      negotiation-points when verdict-is-negotiate)
    (leaf-strings      allowed)))
