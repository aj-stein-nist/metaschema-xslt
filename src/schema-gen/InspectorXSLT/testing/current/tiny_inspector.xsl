<?xml version="1.0" encoding="us-ascii"?>
<xsl:transform xmlns="http://www.w3.org/1999/xhtml"
               xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="3.0"
               xpath-default-namespace="http://example.com/ns/tinydata"
               exclude-result-prefixes="#all"><!-- Generated 2023-11-12T15:07:53.7485307-05:00 -->
   <xsl:mode on-no-match="fail"/>
   <xsl:mode name="test" on-no-match="shallow-skip"/>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--    Templates copied from boilerplate    -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:output indent="true" encoding="us-ascii" omit-xml-declaration="true"/>
   <xsl:param name="format" as="xs:string">inspected</xsl:param>
   <!-- format = (plaintext|markdown|html|mx-report|inspected) -->
   <xsl:param name="form" as="xs:string">full</xsl:param>
   <!-- form = (full|summary|one-line) -->
   <xsl:param name="echo" as="xs:string">none</xsl:param>
   <!-- echo = (none|invalid-only|docs|info|warnings|all) - runtime messaging provided with grab-mx mode - does not work with format=inspected -->
   <xsl:param name="css" as="xs:string"/>
   <!-- Entry points - or use initial-template or initial-mode in supporting processors  -->
   <xsl:template mode="#default"
                 priority="101"
                 name="xsl:initial-template"
                 match="root()[$format='inspected']">
      <xsl:call-template name="inspect"/>
   </xsl:template>
   <xsl:template mode="#default" priority="101" match="root()[$format='mx-report']">
      <xsl:call-template name="mx-report"/>
   </xsl:template>
   <xsl:template mode="#default" priority="101" match="root()[$format='html']">
      <xsl:call-template name="html"/>
   </xsl:template>
   <xsl:template mode="#default" priority="101" match="root()[$format='markdown']">
      <xsl:call-template name="markdown"/>
   </xsl:template>
   <xsl:template mode="#default" priority="101" match="root()[$format='plaintext']">
      <xsl:call-template name="plaintext"/>
   </xsl:template>
   <!-- these modes are reserved for entry points matching "/" and should never match otherwise  -->
   <xsl:mode name="inspect" on-no-match="fail"/>
   <xsl:mode name="mx-report" on-no-match="fail"/>
   <xsl:mode name="mx" on-no-match="fail"/>
   <xsl:mode name="html" on-no-match="fail"/>
   <xsl:mode name="markdown" on-no-match="fail"/>
   <xsl:mode name="md" on-no-match="fail"/>
   <xsl:mode name="plaintext" on-no-match="fail"/>
   <!-- entering with no mode or 'inspect' mode, or by name 'inspect' returns an annotated copy of input tree   -->
   <xsl:template match="/" name="inspect" mode="inspect">
      <mx:validation src="{ base-uri(.) }">
         <xsl:apply-templates select="." mode="metaschema-metadata"/>
         <!-- initiates the actual validation traversal          -->
         <xsl:apply-templates mode="validate"/>
      </mx:validation>
   </xsl:template>
   <xsl:template match="/" mode="mx-report mx">
      <xsl:call-template name="mx-report"/>
   </xsl:template>
   <!-- returns mx reports only, with a summary - can be parameterized to filter -->
   <xsl:template name="mx-report">
      <xsl:variable name="mx-validation">
         <xsl:call-template name="inspect"/>
      </xsl:variable>
      <xsl:apply-templates mode="grab-mx" select="$mx-validation/*"/>
   </xsl:template>
   <xsl:template name="mx">
      <xsl:call-template name="mx-report"/>
   </xsl:template>
   <xsl:template match="/" mode="html">
      <xsl:call-template name="html"/>
   </xsl:template>
   <xsl:template name="html">
      <xsl:variable name="mx-reports">
         <!-- reports has a summary along with any reports -->
         <xsl:call-template name="mx-report"/>
      </xsl:variable>
      <xsl:apply-templates mode="mx-to-html" select="$mx-reports/*"/>
   </xsl:template>
   <xsl:template match="/" mode="markdown md">
      <xsl:call-template name="markdown"/>
   </xsl:template>
   <xsl:template name="markdown">
      <xsl:variable name="html-report">
         <xsl:call-template name="html"/>
      </xsl:variable>
      <xsl:apply-templates mode="html-to-md" select="$html-report/*"/>
   </xsl:template>
   <xsl:template match="/" mode="plaintext">
      <xsl:call-template name="plaintext"/>
   </xsl:template>
   <xsl:template name="plaintext">
      <xsl:variable name="html-report">
         <xsl:call-template name="html"/>
      </xsl:variable>
      <xsl:apply-templates mode="html-to-md" select="$html-report/*">
         <!--single lf passed to override double lf -->
         <xsl:with-param name="lf2"
                         tunnel="true"
                         as="xs:string"
                         select="codepoints-to-string(10)"/>
      </xsl:apply-templates>
   </xsl:template>
   <xsl:template name="md">
      <xsl:call-template name="markdown"/>
   </xsl:template>
   <xsl:mode name="validate" on-no-match="shallow-copy"/>
   <xsl:mode name="value-only" on-no-match="text-only-copy"/>
   <xsl:mode name="validate-markup-line" on-no-match="text-only-copy"/>
   <xsl:mode name="validate-markup-multiline" on-no-match="shallow-skip"/>
   <xsl:mode name="constraint-cascade"
             on-no-match="fail"
             on-multiple-match="use-last"/>
   <xsl:template match="* | @*" priority="1" mode="constraint-cascade"/>
   <xsl:template match="*" mode="validate">
      <xsl:copy>
         <!--<xsl:namespace name="mx">http://csrc.nist.gov/ns/csd/metaschema-xslt</xsl:namespace>-->
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="." mode="test"/>
         <xsl:apply-templates select="@*" mode="test"/>
         <xsl:apply-templates mode="validate"/>
      </xsl:copy>
   </xsl:template>
   <!-- tossing these as preventive measure -->
   <xsl:template mode="validate" match="processing-instruction()"/>
   <!-- as they may however be informative, comments are kept   -->
   <xsl:template mode="validate" match="comment()">
      <xsl:copy-of select="."/>
   </xsl:template>
   <xsl:template match="text()" mode="validate">
      <xsl:apply-templates select="." mode="test"/>
      <xsl:copy-of select="."/>
   </xsl:template>
   <!--   -->
   <!-- wrapper template for testing on each node, to be overridden
         and extended for known elements -->
   <xsl:template match="*" mode="test">
      <!-- report if not recognized -->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.152</xsl:with-param>
         <xsl:with-param name="class">_UE unmatched-element</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="text()[not(matches(., '\S'))]" priority="0.1" mode="test"/>
   <!-- XXX cover all text in mixed content -->
   <xsl:template mode="test"
                 match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text() | pre/text()"/>
   <xsl:template mode="test"
                 match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()"/>
   <xsl:template match="text()" mode="test">
      <!-- report if not recognized -->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.129</xsl:with-param>
         <xsl:with-param name="class">_UT unexpected-text</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Errant text content.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- report if not recognized -->
   <!--<xsl:template match="*" mode="validate-markup-multiline" name="notice-multiline">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.138</xsl:with-param>
         <xsl:with-param name="class">_UMM unmatched-markup-multiline</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi> in multiline
            markup.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>-->
   <xsl:variable name="markup-multline-blocks"
                 select="          'p', 'pre', 'ul', 'ol', 'table',          'h1', 'h2', 'h3', 'h4', 'h5'"/>
   <!--<xsl:template match="p | pre | h1 | h2 | h3 | h5 | h5 | h6 | li | td" mode="validate-markup-multiline">
        <xsl:apply-templates mode="validate-markup-line"/>
    </xsl:template>
    
    <xsl:template match="ul | ol" mode="validate-markup-multiline">
        <xsl:apply-templates select="li" mode="validate-markup-multiline"/>
        <xsl:for-each select="* except li">
            <xsl:call-template name="notice-multiline"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="table" mode="validate-markup-multiline">
        <xsl:apply-templates select="tr" mode="validate-markup-multiline"/>
        <xsl:for-each select="* except tr">
            <xsl:call-template name="notice-multiline"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tr" mode="validate-markup-multiline">
        <xsl:apply-templates select="td" mode="validate-markup-multiline"/>
        <xsl:for-each select="* except td">
            <xsl:call-template name="notice-multiline"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="em | strong | i | b | sub | sup | q | a | insert" mode="validate-markup-line">
        <xsl:apply-templates mode="validate-markup-line"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="validate-markup-line"/>-->
   <!--<xsl:template match="*" mode="validate-markup-line">
      <!-\- report if not recognized -\->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.181</xsl:with-param>
         <xsl:with-param name="class">_UM unmatched-markup</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>-->
   <!-- ... and attributes ...  -->
   <xsl:template match="@*" mode="test"> <!-- validate-markup-line validate-markup-multiline -->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.190</xsl:with-param>
         <xsl:with-param name="class">_UA unmatched-attribute</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized attribute <mx:gi>@{ name() }</mx:gi> on element <mx:gi>{ name(..) }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 mode="test"
                 match="@xsi:*"/>
   <xsl:template name="notice">
      <xsl:param name="cf" as="xs:string" select="AV.199"/>
      <!-- default expecting override -->
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <!-- rule-id may be multiple -->
      <xsl:param name="condition" as="xs:boolean" select="true()"/>
      <xsl:param name="testing" as="xs:string">exists(.)</xsl:param>
      <!-- hints at why something is reported -->
      <xsl:param name="class" as="xs:string">__U uncategorized</xsl:param>
      <xsl:param name="matching" as="xs:string">*</xsl:param>
      <xsl:param name="msg">[info]</xsl:param>
      <xsl:param name="level" as="xs:string">ERROR</xsl:param>
      <xsl:if test="$condition">
         <xsl:variable name="xpath">
            <!-- handmade paths avoid namespaces and other complications of path(.) -->
            <xsl:apply-templates select="." mode="xpath"/>
         </xsl:variable>
         <mx:report cf="{$cf}"
                    test="{ $testing }"
                    class="{$class}"
                    xpath="{ $xpath }"
                    level="{ $level }">
            <xsl:if test="exists($rule-id[matches(., '\S')])">
               <xsl:attribute name="rule-id" select="string-join($rule-id[matches(., '\S')], ' ')"/>
            </xsl:if>
            <xsl:if test="not($matching = '*')">
               <xsl:attribute name="matching" select="$matching"/>
            </xsl:if>
            <xsl:sequence select="$msg"/>
         </mx:report>
      </xsl:if>
   </xsl:template>
   <xsl:template name="echoing">
      <xsl:param name="msg">[info]</xsl:param>
      <xsl:if test="not($echo = 'none')">
         <xsl:message>
            <xsl:sequence select="$msg"/>
         </xsl:message>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="xpath" match="*">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:text expand-text="true">/{ name() }</xsl:text>
   </xsl:template>
   <xsl:template mode="xpath"
                 match="*[node-name() = (../* except current())/node-name()]">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:variable name="kin" select="../*[node-name() = current()/node-name()]"/>
      <xsl:text expand-text="true">/{ name() }[{ mx:element-position(.)[count($kin) gt 1] }]</xsl:text>
   </xsl:template>
   <xsl:template mode="xpath" match="@*">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:text expand-text="true">/@{ name() }</xsl:text>
   </xsl:template>
   <xsl:template mode="xpath" match="text()">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:variable name="kin" select="../text()"/>
      <xsl:variable name="place" expand-text="true">[{ count(preceding-sibling::text()|.) }]</xsl:variable>
      <xsl:text expand-text="true">/text(){ (count($kin)[. gt 1]) ! $place }</xsl:text>
   </xsl:template>
   <xsl:template mode="xpath" match="comment()">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:variable name="kin" select="../comment()"/>
      <xsl:variable name="place" expand-text="true">[{ count(preceding-sibling::comment()|.) }]</xsl:variable>
      <xsl:text expand-text="true">/text(){ (count($kin)[. gt 1]) ! $place }</xsl:text>
   </xsl:template>
   <xsl:template mode="xpath" match="processing-instruction()">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:variable name="kin" select="../processing-instruction()"/>
      <xsl:variable name="place" expand-text="true">[{ count(preceding-sibling::processing-instruction()|.)
         }]</xsl:variable>
      <xsl:text expand-text="true">/text(){ (count($kin)[. gt 1]) ! $place }</xsl:text>
   </xsl:template>
   <!--<xsl:template name="check-datatype">
      <xsl:apply-templates select="." mode="test-datatype"/>
   </xsl:template>-->
   <!--<xsl:template mode="test-datatype" match="*"/>-->
   <xsl:function name="mx:element-position">
      <xsl:param name="for" as="element()"/>
      <xsl:variable name="qname" select="node-name($for)"/>
      <xsl:sequence select="count($for | $for/preceding-sibling::*[node-name() = $qname])"/>
   </xsl:function>
   <xsl:function name="mx:pluralize" as="xs:string" expand-text="true">
      <xsl:param name="for" as="xs:double"/>
      <xsl:param name="as" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$for eq 1">{ $as }</xsl:when>
         <xsl:otherwise>{ $as }s</xsl:otherwise>
         <!-- we could dive into templates if we hit a special case -->
      </xsl:choose>
   </xsl:function>
   <xsl:template name="check-markup-line-datatype">
      <xsl:comment>clean me up</xsl:comment>
      <!--<xsl:apply-templates mode="validate-markup-line"/>-->
   </xsl:template>
   <xsl:template name="check-markup-multiline-datatype">
      <xsl:comment>clean me up</xsl:comment>
   </xsl:template>
   <!-- stub to be replaced with results from produce-datatype-functions.xsl  -->
   <!--<xsl:function name="mx:datatype-validate" as="xs:boolean">
      <xsl:param name="value" as="item()"/>
      <xsl:param name="nominal-type" as="item()?"/>
      <xsl:sequence select="true()"/>
   </xsl:function>-->
   <!-- given a node, a key name, value (sequence) and scope for evaluation, and a sequence of items,
     returns those items that are returned by the key (in document order) -->
   <xsl:function name="mx:key-matches-among-items" as="node()*">
      <xsl:param name="item" as="item()"/>
      <xsl:param name="items" as="item()+"/>
      <xsl:param name="keyname" as="xs:string"/>
      <xsl:param name="keyval" as="item()*"/>
      <xsl:param name="keyscope" as="node()"/>
      <xsl:sequence select="$item!key($keyname,$keyval,$keyscope/root()) intersect $items"/>
   </xsl:function>
   <!-- Mode grab-mx filters mx from its 'host' XML -->
   <xsl:mode name="grab-mx" on-no-match="shallow-skip"/>
   <!--copied from mx-grabber.xsl -->
   <xsl:template match="mx:*" mode="grab-mx">
      <xsl:copy-of select="." copy-namespaces="false"/>
   </xsl:template>
   <!-- Nominally invalid examples has errors or critical along with warning and info reports but no errors or critical -->
   <xsl:template match="/mx:validation[descendant::mx:report/@level = ('CRITICAL', 'ERROR')]"
                 priority="103"
                 mode="grab-mx">
      <xsl:variable name="report-count" select="count(.//mx:report)"/>
      <xsl:variable name="error-count"
                    select="count(.//mx:report[@level = ('CRITICAL', 'ERROR')])"/>
      <xsl:call-template name="echoing" expand-text="true">
         <xsl:with-param name="msg">
            <xsl:choose>
               <xsl:when test="$report-count eq $error-count">File { replace(@src,'.*/','') } has { $error-count } {
                  mx:pluralize($error-count,'error')}.</xsl:when>
               <xsl:otherwise>File { replace(@src,'.*/','') } has { $report-count } {
                  mx:pluralize($report-count,'issue') } reported including { $error-count } {
                  mx:pluralize($error-count,'error')}.</xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <!-- Nominally valid examples may have warning or info reports but no errors or critical -->
   <xsl:template match="/mx:validation[not(descendant::mx:report/@level = ('CRITICAL', 'ERROR'))]"
                 priority="102"
                 mode="grab-mx">
      <xsl:if test="not($echo = 'invalid-only')">
         <xsl:call-template name="echoing" expand-text="true">
            <xsl:with-param name="msg">File { replace(@src,'.*/','') } is reported VALID, no issues ...</xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="/mx:validation" priority="101" mode="grab-mx">
      <xsl:copy copy-namespaces="false">
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="elements"
                        select="count(descendant::* except .//mx:*/descendant-or-self::*)"/>
         <xsl:attribute name="attributes"
                        select="count(descendant::*/@* except .//mx:*/descendant-or-self::*/@*)"/>
         <xsl:attribute name="reports" select="count(.//mx:report)"/>
         <xsl:attribute name="severe-reports"
                        select="count(.//mx:report[@level = ('CRITICAL', 'ERROR')])"/>
         <xsl:apply-templates mode="grab-mx"/>
      </xsl:copy>
   </xsl:template>
   <!-- copy reports but do not announce them -->
   <xsl:template match="mx:report[$echo = ('docs', 'info')][@level = ('ERROR', 'CRITICAL', 'WARNING')]"
                 mode="grab-mx">
      <xsl:copy-of select="." copy-namespaces="false"/>
   </xsl:template>
   <xsl:template match="mx:report[$echo = 'warnings'][@level = ('ERROR', 'CRITICAL')]"
                 mode="grab-mx">
      <xsl:copy-of select="." copy-namespaces="false"/>
   </xsl:template>
   <xsl:template match="mx:report" mode="grab-mx" expand-text="true">
      <xsl:if test="not($form = ('summary', 'one-line'))">
         <xsl:call-template name="echoing" expand-text="true">
            <xsl:with-param name="msg">{ (@level,'ERROR')[1] } [CLASS) { @class } ][PATH) { @xpath } ][REPORT) {
               string(.) }]</xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:next-match/>
   </xsl:template>
   <xsl:mode name="mx-to-html" on-no-match="text-only-copy"/>
   <xsl:template match="/mx:validation" mode="mx-to-html" expand-text="true">
      <xsl:variable name="reported-valid" select="@reports = 0"/>
      <xsl:variable name="validating-filename" select="replace(@src, '.*/', '')"/>
      <xsl:variable name="checked" select="if ($reported-valid) then '&#x2714;' else '&#x2718;'"/>
      <html>
         <head>
            <title>{ $validating-filename } - { $checked } - { mx:metaschema/@shortname } validation</title>
            <xsl:if test="boolean($css)">
               <link rel="stylesheet" href="{ $css }"/>
            </xsl:if>
            <xsl:call-template name="html-css"/>
         </head>
         <body>
            <h1>{ $checked } Validating <a href="{ @src }">{ $validating-filename }</a> - { mx:metaschema } - found {
               'IN'[not($reported-valid)] }VALID</h1>
            <xsl:if test="not($form = 'one-line')">
               <xsl:apply-templates mode="#current" select="mx:metaschema"/>
               <p>
                  <code>{ $validating-filename }</code> contains { @elements} {
                  mx:pluralize(@elements/number(),'element') } and { @attributes } {
                  mx:pluralize(@attributes/number(),'attribute') }.</p>
               <xsl:apply-templates select="." mode="summary"/>
               <xsl:if test="not($form = ('one-line', 'summary'))">
                  <main>
                     <xsl:apply-templates mode="#current" select="child::* except mx:metaschema"/>
                  </main>
               </xsl:if>
            </xsl:if>
         </body>
      </html>
   </xsl:template>
   <xsl:template name="html-css">
      <xsl:if test="not($css)" xml:space="preserve" expand-text="false">
<style type="text/css">
main { max-width: fit-content }
details { margin-top: 0.5em; padding: 0.5em; outline: thin solid black }
details.WARNING { outline: thin dotted grey }
details.INFORMATIONAL { outline: medium solid slateblue }
summary { margin: 0em }
details p { margin: 0.2em 0em }   
.xpath    { font-family: monospace }
.exc { font-size: 85%; padding: 0.2em; background-color: cornsilk; font-family: sans-serif }
</style>
      </xsl:if>
   </xsl:template>
   <xsl:template match="mx:validation" mode="summary" expand-text="true">
      <div class="summary">
         <p>{ count(.//mx:report) } { mx:pluralize(count(.//mx:report),'issue') } reported.</p>
         <p>
            <xsl:iterate select="descendant::mx:report">
               <span class="ji">&#x1f4a5;</span>
            </xsl:iterate>
         </p>
      </div>
   </xsl:template>
   <xsl:template match="mx:validation[empty(descendant::mx:report)]" mode="summary">
      <div class="summary valid">
         <p>Good news - nothing to report - the instance is valid. <span class="ji">&#x1f680;</span>
         </p>
      </div>
   </xsl:template>
   <xsl:template match="mx:metaschema" mode="mx-to-html" expand-text="true">
      <p class="metadata">Checking against the rules defined in metaschema <b>{ . }</b>{ @version ! (', version ' || .)} (namespace <code>{ @namespace
            }</code>)</p>
   </xsl:template>
   <xsl:template match="mx:report" mode="mx-to-html" expand-text="true">
      <details class="report { @class }{ @level[not(.='ERROR')] ! (' ' || .) }">
         <summary>
            <xsl:apply-templates mode="#current"/>
         </summary>
         <p class="exc">{ @class }{ @level[not(.='ERROR')] ! (' ' || .) }</p>
         <ul>
            <xsl:for-each select="@rule-id">
               <li class="test">Rule ID: <code>{ . }</code>
               </li>
            </xsl:for-each>
            <li class="test">test: <code>{ @test }</code>
            </li>
            <xsl:if test="@matching != '*'">
               <li class="matching">matching: <code>{ @matching }</code>
               </li>
            </xsl:if>
            <li>XPath: <code class="xpath">{ @xpath }</code>
            </li>
         </ul>
      </details>
   </xsl:template>
   <xsl:template match="mx:gi" mode="mx-to-html" priority="1">
      <b>
         <xsl:apply-templates mode="#current"/>
      </b>
   </xsl:template>
   <xsl:template match="mx:code | mx:tt" mode="mx-to-html" priority="1">
      <code style="white-space:pre-wrap">
         <xsl:apply-templates mode="#current"/>
      </code>
   </xsl:template>
   <xsl:template match="mx:report/mx:*" mode="mx-to-html">
      <i>
         <xsl:apply-templates mode="#current"/>
      </i>
   </xsl:template>
   <xsl:mode name="html-to-md" on-no-match="text-only-copy"/>
   <xsl:variable name="lf" as="xs:string" expand-text="true">{ codepoints-to-string(10) }</xsl:variable>
   <xsl:template mode="html-to-md"
                 match="html"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current" select="body"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="style"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml"/>
   <xsl:template mode="html-to-md"
                 match="body"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current"/>
      <xsl:text>{ $lf }</xsl:text>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="div | details"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }---</xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="body/*[1]/self::h1"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text># </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="h1"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }# </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="h2"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }## </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="h3 | details/summary"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }### </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="p"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }</xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="ul"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:sequence select="replace($lf2, '&#xA;$', '')"/>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="li"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf }- </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="b"
                 priority="2"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>**</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>**</xsl:text>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="i | p/*"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>*</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>*</xsl:text>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="code"
                 priority="2"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>`</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>`</xsl:text>
   </xsl:template>
   <xsl:template mode="metaschema-metadata" match="*">
      <mx:metaschema version="0.0.5"
                     shortname="computer"
                     namespace="http://example.com/ns/tinydata">Computer Model</mx:metaschema>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--    Generated rules - first, any roots    -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Root     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template match="/TINY" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-TINY-assembly"/>
      <xsl:apply-templates select="." mode="constraint-cascade"/>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Occurrences - templates in mode 'test'     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template priority="5" match="/TINY/part" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::notes)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::notes)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>notes/note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-part-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="TINY/part/part | part/part/part" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::note)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::note)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-part-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="/TINY/title/text()" mode="test"/>
   <xsl:template priority="5" match="/TINY/title" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.309</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::title) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">Element <mx:gi>title</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::term | preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::notes)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::term | preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::notes)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>term</mx:gi>, <mx:gi>stuff</mx:gi>, <mx:gi>part</mx:gi>, or <mx:gi>notes/note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-title-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="/TINY/term/text()" mode="test"/>
   <xsl:template priority="5" match="/TINY/term" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::notes)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::notes)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>stuff</mx:gi>, <mx:gi>part</mx:gi>, or <mx:gi>notes/note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-term-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="/TINY/notes/note/text()" mode="test"/>
   <xsl:template match="/TINY/notes" mode="test"/>
   <xsl:template priority="5" match="/TINY/notes/note" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-note-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="TINY/part/title/text() | part/part/title/text()" mode="test"/>
   <xsl:template priority="5" match="TINY/part/title | part/part/title" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.309</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::title) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">Element <mx:gi>title</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::term | preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::note)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::term | preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::note)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>term</mx:gi>, <mx:gi>stuff</mx:gi>, <mx:gi>part</mx:gi>, or <mx:gi>note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-title-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="TINY/part/term/text() | part/part/term/text()" mode="test"/>
   <xsl:template priority="5" match="TINY/part/term | part/part/term" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::note)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::stuff | preceding-sibling::part | preceding-sibling::note)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>stuff</mx:gi>, <mx:gi>part</mx:gi>, or <mx:gi>note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-term-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="TINY/part/note/text() | part/part/note/text()" mode="test"/>
   <xsl:template priority="5" match="TINY/part/note | part/part/note" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.309</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::note) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::note) gt 1"/>
         <xsl:with-param name="msg">Element <mx:gi>note</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-note-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="/TINY/@id" mode="test">
      <xsl:call-template name="require-for-TINY_..._id-flag"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="TINY/term/@id | part/term/@id" mode="test">
      <xsl:call-template name="require-for-term_..._id-flag"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Fallbacks for occurrences of known elements and attributes, except out of
               context     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template mode="test" match="TINY | title | term | part | note">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.81</xsl:with-param>
         <xsl:with-param name="class">EOOP element-out-of-place</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Element <mx:gi>{ name() }</mx:gi> is not permitted here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test" match="@id">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.90</xsl:with-param>
         <xsl:with-param name="class">AOOP attribute-out-of-place</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Attribute <mx:gi>@{ name() }</mx:gi> is not permitted here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Definitions - a named template for each     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template name="require-for-TINY-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.646</xsl:with-param>
         <xsl:with-param name="class">MRQA missing-required-attribute</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(@id)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">Element <mx:gi>{ name() }</mx:gi> requires attribute <mx:gi>@id</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.419</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(title)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(title)"/>
         <xsl:with-param name="msg" expand-text="true">Element <mx:gi>{ name() }</mx:gi> requires element <mx:gi>title</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-TINY_..._id-flag"/>
   <xsl:template name="require-for-TINY_..._stuff-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-term-field">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.646</xsl:with-param>
         <xsl:with-param name="class">MRQA missing-required-attribute</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(@id)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">Element <mx:gi>{ name() }</mx:gi> requires attribute <mx:gi>@id</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="check-string-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-term_..._id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-note-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-part-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.419</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(title)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(title)"/>
         <xsl:with-param name="msg" expand-text="true">Element <mx:gi>{ name() }</mx:gi> requires element <mx:gi>title</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-part_..._stuff-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Datatypes - a named template for each occurring     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template name="check-string-datatype">
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <xsl:param name="class" as="xs:string">VDSX violates-datatype-syntax</xsl:param>
      <xsl:param name="matching" as="xs:string?" select="()"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.121</xsl:with-param>
         <xsl:with-param name="rule-id" as="xs:string*" select="$rule-id"/>
         <xsl:with-param name="matching"
                         as="xs:string"
                         select="($matching[matches(.,'\S')],'*')[1]"/>
         <xsl:with-param name="class" as="xs:string" expand-text="true">{ $class }</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(string(.) castable as xs:string and matches(.,'^\S(.*\S)?$'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(string(.) castable as xs:string and matches(.,'^\S(.*\S)?$'))"/>
         <xsl:with-param name="msg" expand-text="true">Value <mx:code>{ string(.) }</mx:code> of { if (self::element()) then 'element' else 'attribute' } <mx:gi>{ self::attribute()/'@' }{ name(.) }</mx:gi> does not conform to <mx:code>string</mx:code> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-token-datatype">
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <xsl:param name="class" as="xs:string">VDSX violates-datatype-syntax</xsl:param>
      <xsl:param name="matching" as="xs:string?" select="()"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.121</xsl:with-param>
         <xsl:with-param name="rule-id" as="xs:string*" select="$rule-id"/>
         <xsl:with-param name="matching"
                         as="xs:string"
                         select="($matching[matches(.,'\S')],'*')[1]"/>
         <xsl:with-param name="class" as="xs:string" expand-text="true">{ $class }</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(string(.) castable as xs:string and matches(.,'^(\p{L}|_)(\p{L}|\p{N}|[.\-_])*$') and matches(.,'^\S(.*\S)?$'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(string(.) castable as xs:string and matches(.,'^(\p{L}|_)(\p{L}|\p{N}|[.\-_])*$') and matches(.,'^\S(.*\S)?$'))"/>
         <xsl:with-param name="msg" expand-text="true">Value <mx:code>{ string(.) }</mx:code> of { if (self::element()) then 'element' else 'attribute' } <mx:gi>{ self::attribute()/'@' }{ name(.) }</mx:gi> does not conform to <mx:code>token</mx:code> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test"
                 match="title/em|title/i|title/strong|title/b|title/insert|title/a|title/q|title/code|title/sup|title/sub"/>
   <xsl:template mode="test"
                 match="TINY/p|TINY/ul|TINY/ol|TINY/table|TINY/pre|TINY/h1|TINY/h2|TINY/h3|TINY/h4|TINY/h5|TINY/h6">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::part | preceding-sibling::notes)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::part | preceding-sibling::notes)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>part</mx:gi> or <mx:gi>notes/note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test"
                 match="part/p|part/ul|part/ol|part/table|part/pre|part/h1|part/h2|part/h3|part/h4|part/h5|part/h6">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.352</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::part | preceding-sibling::note)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::part | preceding-sibling::note)"/>
         <xsl:with-param name="msg">Element <mx:gi>{ name(.) }</mx:gi> is unexpected following <mx:gi>part</mx:gi> or <mx:gi>note</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test"
                 match="p/em|ul/em|ol/em|table/em|pre/em|h1/em|h2/em|h3/em|h4/em|h5/em|h6/em"/>
   <xsl:template mode="test"
                 match="em/em|i/em|strong/em|b/em|insert/em|a/em|q/em|code/em|sup/em|sub/em"/>
   <xsl:template mode="test"
                 match="p/i|ul/i|ol/i|table/i|pre/i|h1/i|h2/i|h3/i|h4/i|h5/i|h6/i"/>
   <xsl:template mode="test"
                 match="em/i|i/i|strong/i|b/i|insert/i|a/i|q/i|code/i|sup/i|sub/i"/>
   <xsl:template mode="test"
                 match="p/strong|ul/strong|ol/strong|table/strong|pre/strong|h1/strong|h2/strong|h3/strong|h4/strong|h5/strong|h6/strong"/>
   <xsl:template mode="test"
                 match="em/strong|i/strong|strong/strong|b/strong|insert/strong|a/strong|q/strong|code/strong|sup/strong|sub/strong"/>
   <xsl:template mode="test"
                 match="p/b|ul/b|ol/b|table/b|pre/b|h1/b|h2/b|h3/b|h4/b|h5/b|h6/b"/>
   <xsl:template mode="test"
                 match="em/b|i/b|strong/b|b/b|insert/b|a/b|q/b|code/b|sup/b|sub/b"/>
   <xsl:template mode="test"
                 match="p/insert|ul/insert|ol/insert|table/insert|pre/insert|h1/insert|h2/insert|h3/insert|h4/insert|h5/insert|h6/insert"/>
   <xsl:template mode="test"
                 match="em/insert|i/insert|strong/insert|b/insert|insert/insert|a/insert|q/insert|code/insert|sup/insert|sub/insert"/>
   <xsl:template mode="test"
                 match="p/a|ul/a|ol/a|table/a|pre/a|h1/a|h2/a|h3/a|h4/a|h5/a|h6/a"/>
   <xsl:template mode="test"
                 match="em/a|i/a|strong/a|b/a|insert/a|a/a|q/a|code/a|sup/a|sub/a"/>
   <xsl:template mode="test"
                 match="p/q|ul/q|ol/q|table/q|pre/q|h1/q|h2/q|h3/q|h4/q|h5/q|h6/q"/>
   <xsl:template mode="test"
                 match="em/q|i/q|strong/q|b/q|insert/q|a/q|q/q|code/q|sup/q|sub/q"/>
   <xsl:template mode="test"
                 match="p/code|ul/code|ol/code|table/code|pre/code|h1/code|h2/code|h3/code|h4/code|h5/code|h6/code"/>
   <xsl:template mode="test"
                 match="em/code|i/code|strong/code|b/code|insert/code|a/code|q/code|code/code|sup/code|sub/code"/>
   <xsl:template mode="test"
                 match="p/sup|ul/sup|ol/sup|table/sup|pre/sup|h1/sup|h2/sup|h3/sup|h4/sup|h5/sup|h6/sup"/>
   <xsl:template mode="test"
                 match="em/sup|i/sup|strong/sup|b/sup|insert/sup|a/sup|q/sup|code/sup|sup/sup|sub/sup"/>
   <xsl:template mode="test"
                 match="p/sub|ul/sub|ol/sub|table/sub|pre/sub|h1/sub|h2/sub|h3/sub|h4/sub|h5/sub|h6/sub"/>
   <xsl:template mode="test"
                 match="em/sub|i/sub|strong/sub|b/sub|insert/sub|a/sub|q/sub|code/sub|sup/sub|sub/sub"/>
</xsl:transform>
