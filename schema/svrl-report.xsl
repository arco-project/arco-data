<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs svrl">

  <xsl:output method="text"/>
  <xsl:param name="svrl-dir" as="xs:string" select="'build/svrl'"/>

  <xsl:template name="main">
    <xsl:for-each select="collection($svrl-dir || '?select=*.xml;recurse=yes')">
      <xsl:sort select="document-uri(.)"/>
      <xsl:variable name="failures" select=".//svrl:failed-assert | .//svrl:successful-report"/>
      <xsl:if test="exists($failures)">
        <xsl:variable name="source" select="(.//svrl:fired-rule/@document)[1]"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:value-of select="replace($source, '^file:.*/arco-data/', '')"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$failures">
          <xsl:text>  - </xsl:text>
          <xsl:value-of select="normalize-space(svrl:text)"/>
          <xsl:text>&#10;      at </xsl:text>
          <xsl:value-of select="replace(@location, 'Q\{[^}]*\}', '')"/>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>