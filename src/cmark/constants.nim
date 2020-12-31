const
  CMARK_OPT_DEFAULT* = 0
    ## Default options.

  CMARK_OPT_SOURCEPOS* = 1 shl 1
    ## Include a `data-sourcepos` attribute on all block elements.

  CMARK_OPT_HARDBREAKS* = 1 shl 2
    ## Render `softbreak` elements as hard line breaks.

  CMARK_OPT_SAFE* = 1 shl 3
    ## `CMARK_OPT_SAFE` is defined here for API compatibility,
    ## but it no longer has any effect. "Safe" mode is now the default:
    ## set `CMARK_OPT_UNSAFE` to disable it.

  CMARK_OPT_UNSAFE* = 1 shl 17
    ## Render raw HTML and unsafe links (`javascript:`, `vbscript:`,
    ## `file:`, and `data:`, except for `image/png`, `image/gif`,
    ## `image/jpeg`, or `image/webp` mime types).  By default,
    ## raw HTML is replaced by a placeholder HTML comment. Unsafe
    ## links are replaced by empty strings.

  CMARK_OPT_NOBREAKS* = 1 shl 4
    ## Render `softbreak` elements as spaces.

  CMARK_OPT_NORMALIZE* = 1 shl 8
    ## Legacy option (no effect).

  CMARK_OPT_VALIDATE_UTF8* = 1 shl 9
    ## Validate UTF-8 in the input before parsing, replacing illegal
    ## sequences with the replacement character U+FFFD.

  CMARK_OPT_SMART* = 1 shl 10
    ## Convert straight quotes to curly, `---` to em dashes, `--` to
    ## en dashes.

  CMARK_OPT_GITHUB_PRE_LANG* = 1 shl 11
    ## Generate GitHub <pre lang="lang">-style codeblocks instead of <pre><code class="language-lang"> ones
  
  CMARK_OPT_LIBERAL_HTML_TAG* = 1 shl 12
    ## Be liberal in interpreting inline HTML tags.
  
  CMARK_OPT_FOOTNOTES* = 1 shl 13
    ## Parse footnotes
  
  CMARK_OPT_STRIKETHROUGH_DOUBLE_TILDE* = 1 shl 14
    ## Only parse strikethroughs if surrounded by exactly 2 tildes. Gives some compatibility with redcarpet.

  CMARK_OPT_TABLE_PREFER_STYLE_ATTRIBUTES* = 1 shl 15
    ## Use style attributes to align table cells instead of align attributes.
  
  CMARK_OPT_FULL_INFO_STRING* = 1 shl 16
    ## Include the remainder of the info string in code blocks in a separate attribute.