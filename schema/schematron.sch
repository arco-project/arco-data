<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <s:title>Schematron</s:title>
   <s:ns prefix="tei" uri="http://www.tei-c.org/ns/1.0" />
   <s:pattern>
      <s:rule context="tei:titleStmt">
         <s:assert test="tei:title[@level='m']">
            Missing tei:titleStmt/tei:title[@level="m"] element
         </s:assert>
         <s:assert test="tei:title[@level='a']">
            Missing tei:titleStmt/tei:title[@level="a"] element
         </s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="pointer-resolves">
      <s:rule context="@corresp | @ref | @target | @source | @ana">
         <s:let name="base" value="base-uri(.)" />
         <s:assert
            test="
            every $t in tokenize(normalize-space(.), '\s+')[not(matches(., '^[a-zA-Z][a-zA-Z0-9+.-]*:'))]
            satisfies
                contains($t, '#')
                and (
                    if (starts-with($t, '#'))
                    then exists(root(current())//*[@xml:id = substring-after($t, '#')])
                    else (
                        let $uri := resolve-uri(
                            (if (starts-with($t, 'list')) then concat('../indices/', $t) else $t), $base)
                        return
                            doc-available(substring-before($uri, '#'))
                            and exists(doc(substring-before($uri, '#'))//*[@xml:id = substring-after($t, '#')])
                    )
                )
        ">
            @<s:value-of select="name()" /> "<s:value-of select="." />" does not resolve to an
            existing element with a matching xml:id. </s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
