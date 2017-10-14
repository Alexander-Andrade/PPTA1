module GrammarRegexp
  CHAIN = /[A-Za-z0-9λε#~&]+/
  RULE = /^(?<left>#{CHAIN})->(?<right>#{CHAIN}(\|#{CHAIN})*)$/

  N = /[A-Z]/
  T = /[a-z0-9λε#~&]/
  LEFT_REGULAR_RULE = /^#{N}->(#{N}#{T}|#{T})(\|(#{N}#{T}|#{T}))*$/
  RIGHT_REGULAR_RULE = /^#{N}->(#{T}#{N}|#{T})(\|(#{T}#{N}|#{T}))*$/

end
