; extends

; NOTE: see `nix/injections.scm` for reference

; /* sql */ - style Comments
((block_comment) @injection.language
  . ; this is to make sure only adjacent comments are accounted for the injections
  [
    (string_literal
      (string_content) @injection.content)
    (raw_string_literal
      (string_content) @injection.content)
  ]
  (#gsub! @injection.language "/%*%s*([%w%p]+)%s*%*/" "%1")
  (#set! injection.combined))
