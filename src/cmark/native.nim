when defined(Windows):
  const libcmark = "cmark.dll"
elif defined(MacOsX):
  const libcmark = "libcmark.dylib"
else:
  const libcmark = "libcmark.so"

include "./constants"

type
  NodeType* = enum ## cmark node types.
    ntNone
      ## Error status

    # Block
    ntDocument
    ntBlockQuote
    ntList
    ntItem
    ntCodeBlock
    ntHtmlBlock
    ntCustomBlock
    ntParagraph
    ntHeading
    ntThematicBreak

    # Inline
    ntText
    ntSoftBreak
    ntLineBreak
    ntCode
    ntHtmlInline
    ntCustomInline
    ntEmph
    ntStrong
    ntLink
    ntImage

  NodeBlock* = range[ntDocument..ntThematicBreak] ## Node block types range.
  NodeInline* = range[ntText..ntImage] ## Node inline types range.

  ListType* = enum
    ltNoList
    ltBulletList
    ltOrderedList

  DelimType* = enum ## Delimiter types.
    dtNoDelim       ## No delimiter
    dtPeriodDelim   ## Period delimiter: `[]`
    dtParenDelim    ## Parenthesis delimiter: `()`

  EventType* = enum ## Event types.
    etNone
    etDone
    etEnter
    etExit

  Node* = object ## `struct cmark_node`
  NodePtr* = ptr Node ## `cmark_node*`

  Parser* = object ## `struct cmark_parser`
  ParserPtr* = ptr Parser ## `cmark_parser*`

  Iter* = object ## `struct cmark_iter`
  IterPtr* = ptr Iter ## `cmark_iter*`

{.push dynlib: libcmark.}

# === Simple Interface ===

proc cmark_markdown_to_html*(text: cstring, len: csize_t, opt: cint): cstring {.importc.}
  ## Convert 'text' (assumed to be a UTF-8 encoded string with length 'len') from
  ## CommonMark Markdown to HTML, returning a null-terminated, UTF-8-encoded string.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_markdown_to_html(const char *text, size_t len, int options);`


# === Creating and Destroying Nodes ===

proc cmark_node_new*(nodeType: NodeType): NodePtr {.importc.}
  ## Creates a new node of type `nodeType`.
  ##
  ## Note that the node may have other required properties, which it is the
  ## caller's responsibility to assign.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_new(cmark_node_type type);`

proc cmark_node_free*(node: NodePtr): void {.importc.}
  ## Frees the memory allocated for a node and any children.
  ##
  ## Native function signature:
  ## `void cmark_node_free(cmark_node *node);`


# === Tree Traversal ===

proc cmark_node_next*(node: NodePtr): NodePtr {.importc.}
  ## Returns the next node in the sequence after `node`, or `nil` if there is none.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_next(cmark_node *node);`

proc cmark_node_previous*(node: NodePtr): NodePtr {.importc.}
  ## Returns the previous node in the sequence after `node`, or `nil` if there is none.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_previous(cmark_node *node);`

proc cmark_node_parent*(node: NodePtr): NodePtr {.importc.}
  ## Returns the parent of `node`, or `nil` if there is none.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_parent(cmark_node *node);`

proc cmark_node_first_child*(node: NodePtr): NodePtr {.importc.}
  ## Returns the first child of `node`, or `nil` if `node` has no children.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_first_child(cmark_node *node);`

proc cmark_node_last_child*(node: NodePtr): NodePtr {.importc.}
  ## Returns the last child of `node`, or `nil` if `node` has no children.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_last_child(cmark_node *node);`


# === Parsing ===
proc cmark_parse_document*(text: cstring, len: csize_t, opt: cint): NodePtr {.importc.}
  ## **Simple interface**
  ##
  ## Parse a CommonMark document in `text` of length `len`.
  ## Returns a pointer to a tree of nodes.
  ##
  ## The memory allocated for the node tree should be released
  ## using `cmark_node_free` when it is no longer needed.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_parse_document(const char *buffer, size_t len, int options);`

proc cmark_parser_new*(opt: cint): ParserPtr {.importc.}
  ## Creates a new parser object.
  ##
  ## Native function signature:
  ## `cmark_parser *cmark_parser_new(int options);`

proc cmark_parser_free*(p: ParserPtr): void {.importc.}
  ## Frees memory allocated for a parser object.
  ##
  ## Native function signature:
  ## `void cmark_parser_free(cmark_parser *parser);`


# === Rendering ===

proc cmark_render_xml*(root: NodePtr, opt: cint): cstring {.importc.}
  ## Render a `node` tree as XML.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_xml(cmark_node *root, int options);`

proc cmark_render_html*(root: NodePtr, opt: cint): cstring {.importc.}
  ## Render a `node` tree as an HTML fragment.
  ##
  ## It is up to the user to add an appropriate header and footer.
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_html(cmark_node *root, int options);`

proc cmark_render_man*(root: NodePtr, opt, width: cint): cstring {.importc.}
  ## Render a `node` tree as a groff man page, without the header.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_man(cmark_node *root, int options, int width);`

proc cmark_render_commonmark*(root: NodePtr, opt, width: cint): cstring {.importc.}
  ## Render a `node` tree as a commonmark document.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_commonmark(cmark_node *root, int options, int width);`

proc cmark_render_latex*(root: NodePtr, opt, width: cint): cstring {.importc.}
  ## Render a `node` tree as a LaTeX document.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_latex(cmark_node *root, int options, int width);`


# === Version information ===

proc cmark_version*(): cint {.importc.}
  ## The library version as integer for runtime checks.
  ##
  ## In hexadecimal format, the number `0x010203` represents version `1.2.3`.
  ##
  ## Native function signature:
  ## `int cmark_version(void);`

proc cmark_version_string*(): cstring {.importc.}
  ## The library version string for runtime checks.
  ##
  ## Native function signature:
  ## `const char *cmark_version_string(void);`

{.pop.}

proc free*(str: pointer): void {.importc.}
  ## `free()` function in C library. (`stdlib.h`)
  ##
  ## Native function signature:
  ## `void free(void *);`

