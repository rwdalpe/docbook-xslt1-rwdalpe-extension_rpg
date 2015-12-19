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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:rpg="http://docbook.org/ns/docbook"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="xsl db rpg h exsl">

  <xsl:template match="rpg:settlement">
    <div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
      <xsl:apply-templates mode="settlement"/>
    </div>
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
    <div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates mode="settlement"/>
    </div>
  </xsl:template>
  
  <xsl:template match="rpg:settlementdisadvantages" mode="settlement">
    <span>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates mode="settlement"/>
    </span>
  </xsl:template>

  <xsl:template match="rpg:settlement/rpg:settlementdanger" mode="settlement">
    <span class="{local-name(.)}-container">
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates select=".">
        <xsl:with-param name="prependSpace" select="true()"/>
      </xsl:apply-templates>
    </span>
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
    <div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates mode="settlement"/>
    </div>
  </xsl:template>
  
  <xsl:template match="rpg:demographics/rpg:government" mode="settlement">
    <span class="{local-name(.)}-container">
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="."/>
    </span>
  </xsl:template>
  
  <xsl:template match="rpg:demographics/rpg:populations" mode="settlement">
    <xsl:variable name="makeTotal" select="@total or (count(./rpg:population) > 1 and count(./rpg:population[not(@count)]) = 0)"/>
    
    <div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
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
          <span class="{local-name(.)}-total"><xsl:value-of select="$total"/></span>
          <xsl:text> (</xsl:text><xsl:apply-templates mode="settlement"/><xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="settlement"/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
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
      <h:attrs>
      	<h:attr>base</h:attr>
      	<h:attr>limit</h:attr>
      	<h:attr>casting</h:attr>
      	<h:attr>minor</h:attr>
      	<h:attr>medium</h:attr>
      	<h:attr>major</h:attr>
      </h:attrs>
    </xsl:variable>
    <xsl:variable name="lineBreakers" select="$attrs/h:attrs/h:attr[3]"/>
    <xsl:variable name="localName" select="local-name(.)"/>
    <xsl:variable name="node" select="."/>
  
    <div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:variable name="nodeattrs" select="exsl:node-set($attrs)"/>
      <xsl:for-each select="$attrs//h:attr">
        <xsl:variable name="name" select="./text()"/>
        <span class="{$name}-container">
            <span class="{$name}-title">
                <xsl:variable name="nodelang">
                	<xsl:call-template name="l10n.language">
                		<xsl:with-param name="target" select="$node"/>
                	</xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="gentext">
                    <xsl:with-param name="lang" select="$nodelang"/>
                    <xsl:with-param name="key" select="concat(concat($localName,'-'),$name)"/>
                </xsl:call-template>
            </span>
            <xsl:text> </xsl:text>
            <span class="{$name}-value">
                <xsl:choose>
                    <xsl:when test="$node/@*[starts-with(name(),$name)]">
                        <xsl:value-of select="$node/@*[starts-with(name(),$name)]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#x2014;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:if test="count($lineBreakers[text() = $name]) = 0 and position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:if test="not(count($lineBreakers[text() = $name]) = 0)">
                <br/>
            </xsl:if>
        </span>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>