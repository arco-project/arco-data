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
   <s:pattern id="corresp-index-resolves">
      <s:rule
         context="@corresp[
        some $t in tokenize(., '\s+')
        satisfies starts-with($t, '../indices/')
    ]">
         <s:let name="base" value="base-uri(.)" />

         <s:assert
            test="
            every $t in tokenize(., '\s+')[starts-with(., '../indices/')]
            satisfies
                contains($t, '#')
                and
                doc-available(resolve-uri(substring-before($t, '#'), $base))
                and
                exists(
                    doc(resolve-uri(substring-before($t, '#'), $base))
                    //*[@xml:id = substring-after($t, '#')]
                )
        ">
            @corresp "<s:value-of select="." />" contains an index reference that does not resolve
            to an existing element with a matching xml:id. </s:assert>
      </s:rule>
   </s:pattern>
</s:schema>