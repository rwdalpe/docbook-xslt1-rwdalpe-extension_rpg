<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Copyright (C) 2015 Robert Winslow Dalpe
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.
  
  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:db="http://docbook.org/ns/docbook"
	xmlns:rpg="http://docbook.org/ns/docbook"
	xmlns="http://www.w3.org/1999/XSL/Format"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:exsl="http://exslt.org/common"
	exclude-result-prefixes="xsl db fo rpg exsl">

  <xsl:template match="rpg:settlement">
    <fo:block>
			<xsl:call-template name="anchor"/>
			<fo:block border="thin solid black">
				<xsl:apply-templates select="./rpg:location" mode="settlement"/>
			</fo:block>
			<fo:block>
				<xsl:apply-templates select="./rpg:alignment" mode="settlement"/>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:settlementtype" mode="settlement"/>
			</fo:block>
			<xsl:apply-templates select="./rpg:abilityscores | ./rpg:settlementqualities" mode="settlement"/>
			<fo:block>
				<xsl:apply-templates select="./rpg:settlementdanger" mode="settlement"/>
			</fo:block>
			<xsl:apply-templates select="./rpg:demographics | ./rpg:marketplace" mode="settlement"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="*" mode="settlement">
  	<xsl:apply-templates select="."/>
  </xsl:template>
  
  <xsl:template match="rpg:settlement/rpg:abilityscores" mode="settlement">
    <xsl:apply-templates select=".">
      <xsl:with-param name="separator" select="'; '"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="rpg:settlementqualities" mode="settlement">
    <fo:block>
			<xsl:call-template name="anchor"/>
      <fo:inline >
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </fo:inline>
      <xsl:apply-templates mode="settlement"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="rpg:settlementdisadvantages" mode="settlement">
    <fo:wrapper>
			<xsl:call-template name="anchor"/>
      <fo:inline >
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </fo:inline>
      <xsl:apply-templates mode="settlement"/>
    </fo:wrapper>
  </xsl:template>

  <xsl:template match="rpg:settlement/rpg:settlementdanger" mode="settlement">
    <fo:wrapper >
      <fo:inline >
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </fo:inline>
      <xsl:apply-templates select=".">
        <xsl:with-param name="prependSpace" select="true()"/>
      </xsl:apply-templates>
    </fo:wrapper>
    <xsl:if test="following-sibling::rpg:settlementdisadvantages">
        <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rpg:settlementquality|rpg:settlementdisadvantage" mode="settlement">
    <xsl:param name="separator" select="', '"/>
  
    <xsl:apply-templates select="."/>
    <xsl:if test="following-sibling::rpg:settlementquality">
      <xsl:value-of select="$separator"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rpg:demographics" mode="settlement">
    <fo:block>
			<xsl:call-template name="anchor"/>
      <fo:block >
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </fo:block>
      <xsl:apply-templates mode="settlement"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="rpg:demographics/rpg:government" mode="settlement">
    <fo:wrapper >
      <fo:inline >
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </fo:inline>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="."/>
    </fo:wrapper>
  </xsl:template>
  
  <xsl:template match="rpg:demographics/rpg:populations" mode="settlement">
    <xsl:variable name="makeTotal" select="@total or (count(./rpg:population) > 1 and count(./rpg:population[not(@count)]) = 0)"/>
    
    <fo:block>
			<xsl:call-template name="anchor"/>
      <fo:wrapper >
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </fo:wrapper>
      <xsl:choose>
        <xsl:when test="$makeTotal">
          <xsl:variable name="total">
            <xsl:choose>
              <xsl:when test="@total">
                   <xsl:value-of select="@total"/>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:value-of select="sum(./rpg:population/@count)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:text> </xsl:text>
          <fo:inline ><xsl:value-of select="$total"/></fo:inline>
          <xsl:text> (</xsl:text><xsl:apply-templates mode="settlement"/><xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="settlement"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="rpg:populations/rpg:population" mode="settlement">
    <xsl:variable name="separator" select="'; '"/>
    
    <xsl:apply-templates select="."/>
    
    <xsl:if test="following-sibling::rpg:population">
      <xsl:value-of select="$separator"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rpg:marketplace" mode="settlement">
    <xsl:variable name="attrs">
      <fo:attrs>
      	<fo:attr>base</fo:attr>
      	<fo:attr>limit</fo:attr>
      	<fo:attr>casting</fo:attr>
      	<fo:attr>minor</fo:attr>
      	<fo:attr>medium</fo:attr>
      	<fo:attr>major</fo:attr>
      </fo:attrs>
    </xsl:variable>
    <xsl:variable name="lineBreakers" select="$attrs/fo:attrs/fo:attr[3]"/>
    <xsl:variable name="localName" select="local-name(.)"/>
    <xsl:variable name="node" select="."/>
  
    <fo:block>
			<xsl:call-template name="anchor"/>
      <fo:block>
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </fo:block>
      <xsl:variable name="nodeattrs" select="exsl:node-set($attrs)"/>
      <xsl:for-each select="$attrs//fo:attr">
        <xsl:variable name="name" select="./text()"/>
        <fo:wrapper >
            <fo:inline >
                <xsl:variable name="nodelang">
                	<xsl:call-template name="l10n.language">
                		<xsl:with-param name="target" select="$node"/>
                	</xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="gentext">
                    <xsl:with-param name="lang" select="$nodelang"/>
                    <xsl:with-param name="key" select="concat(concat($localName,'-'),$name)"/>
                </xsl:call-template>
            </fo:inline>
            <xsl:text> </xsl:text>
            <fo:inline >
                <xsl:choose>
                    <xsl:when test="$node/@*[starts-with(name(),$name)]">
                        <xsl:value-of select="$node/@*[starts-with(name(),$name)]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#x2014;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:inline>
            <xsl:if test="count($lineBreakers[text() = $name]) = 0 and position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:if test="not(count($lineBreakers[text() = $name]) = 0)">
                <fo:block/>
            </xsl:if>
        </fo:wrapper>
      </xsl:for-each>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>