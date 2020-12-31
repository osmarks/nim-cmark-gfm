include "cmark/constants"

import cmark/native

type MarkdownError* = object of CatchableError

proc mdError*(msg: string) {.noreturn, noinline.} =
  var e: ref MarkdownError
  new(e)
  e.msg = msg
  raise e

proc cmark_version*(): string =
  result = $native.cmark_version_string()

proc markdown_to_html*(text: string, opt: int): string =
  let
    str: cstring = text
    len: csize_t = len(text).csize_t

  let html: cstring = cmark_markdown_to_html(str, len, opt.cint)
  defer: free(html)

  result = $html

proc markdown_to_html*(text: string, opt: int, extensions: seq[string]): string =
  cmark_gfm_core_extensions_ensure_registered()

  let
    str: cstring = text
    len: csize_t = len(text).csize_t
    parser: ParserPtr = cmark_parser_new(opt.cint)
  if parser == nil: mdError("failed to initialize parser")
  defer: cmark_parser_free(parser)

  for ext in extensions:
    let e: cstring = ext
    let eptr = cmark_find_syntax_extension(e)
    if eptr == nil: mdError("failed to find extension " & ext)
    if cmark_parser_attach_syntax_extension(parser, eptr) == 0: mdError("failed to attach extension " & ext)

  cmark_parser_feed(parser, str, len)
  let doc = cmark_parser_finish(parser)
  defer: cmark_node_free(doc)
  if doc == nil: mdError("parsing failed")

  let html: cstring = cmark_render_html(doc, opt.cint, cmark_parser_get_syntax_extensions(parser))
  defer: free(html)

  result = $html