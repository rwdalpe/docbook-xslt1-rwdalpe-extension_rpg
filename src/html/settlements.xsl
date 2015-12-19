<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Copyright (C) 2014 Robert Winslow Dalpe
  
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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook" xmlns:f="http://docbook.org/xslt/ns/extension"
  xmlns:rpg="http://docbook.org/ns/docbook"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  
  exclude-result-prefixes="xsl db f rpg h xs">

  <xsl:template match="rpg:settlement">
    <div>
      <xsl:sequence select="f:html-attributes(.)" />
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rpg:settlement/rpg:abilityscores">
    <xsl:next-match>
      <xsl:with-param name="separator" select="'; '"/>
    </xsl:next-match>
  </xsl:template>
  
  <xsl:template match="rpg:settlementqualities">
    <div>
      <xsl:sequence select="f:html-attributes(.)"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rpg:settlementdisadvantages">
    <span>
      <xsl:sequence select="f:html-attributes(.)"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="rpg:settlement/rpg:settlementdanger">
    <span class="{local-name(.)}-container">
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:next-match>
        <xsl:with-param name="prependSpace" select="true()"/>
      </xsl:next-match>
    </span>
    <xsl:if test="following-sibling::rpg:settlementdisadvantages">
        <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rpg:settlementquality|rpg:settlementdisadvantage">
    <xsl:param name="separator" as="xs:string" select="', '"/>
  
    <xsl:next-match/>
    <xsl:if test="following-sibling::rpg:settlementquality">
      <xsl:value-of select="$separator"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rpg:demographics">
    <div>
      <xsl:sequence select="f:html-attributes(.)"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rpg:demographics/rpg:government">
    <span class="{local-name(.)}-container">
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:text> </xsl:text>
      <xsl:next-match/>
    </span>
  </xsl:template>
  
  <xsl:template match="rpg:demographics/rpg:populations">
    <xsl:variable name="makeTotal" select="@total or (count(./rpg:population) > 1 and count(./rpg:population[not(@count)]) = 0)"/>
    
    <div>
      <xsl:sequence select="f:html-attributes(.)"/>
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
          <xsl:text> (</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <xsl:template match="rpg:populations/rpg:population">
    <xsl:variable name="separator" select="'; '"/>
    
    <xsl:next-match/>
    
    <xsl:if test="following-sibling::rpg:population">
      <xsl:value-of select="$separator"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rpg:marketplace">
    <xsl:variable name="attrs" as="xs:string+" select="('base','limit','casting','minor','medium','major')"/>
    <xsl:variable name="lineBreakers" as="xs:string+" select="($attrs[3])"/>
    <xsl:variable name="localName" select="local-name(.)"/>
    <xsl:variable name="node" select="."/>
  
    <div>
      <xsl:sequence select="f:html-attributes(.)"/>
      <span class="{local-name(.)}-title">
        <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="local-name(.)"/>
        </xsl:call-template>
      </span>
      <xsl:for-each select="$attrs">
        <xsl:variable name="name" select="."/>
        <span class="{$name}-container">
            <span class="{$name}-title">
                <xsl:call-template name="gentext">
                    <xsl:with-param name="lang" select="f:l10n-language($node)"/>
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
            <xsl:if test="empty(index-of($lineBreakers, $name)) and position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:if test="not(empty(index-of($lineBreakers, $name)))">
                <br/>
            </xsl:if>
        </span>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>