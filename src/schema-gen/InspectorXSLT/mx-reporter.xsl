<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
    exclude-result-prefixes="#all"
     expand-text="true">

    <xsl:output indent="yes"/>

    <!-- fails except on /mx:validation documents -->
    <xsl:mode on-no-match="text-only-copy"/>
    
    <!-- Provides functions and processes for handling documents with mx elements
     interspersed. Filter them out but also count them-->

    <xsl:function name="mx:pull-reports" as="element()*">
        <xsl:param name="rr" as="node()*"/>
        <xsl:apply-templates mode="grab-mx" select="$rr"/>
    </xsl:function>


    <xsl:template match="/mx:validation">
        <html>
            <xsl:apply-templates/>
        </html>
    </xsl:template>
    
    <xsl:template match="mx:report">
        <div class="report { @cat }">
            <p class="test">{ @test }</p>
            <p class="xpath">{ @xpath }</p>
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <xsl:template match="mx:gi">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    
</xsl:stylesheet>
