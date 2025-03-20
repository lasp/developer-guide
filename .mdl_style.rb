all
exclude_rule 'MD014'  # Dollar signs used before commands without showing output
exclude_rule 'MD029'  # Ordered list item prefix
exclude_rule 'MD033'  # Inline HTML
exclude_rule 'MD034'  # Bare URL used
exclude_rule 'MD036'  # Emphasis used instead of a header
rule 'MD013', :line_length => 120, :ignore_code_blocks => true, :tables => false