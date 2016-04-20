<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright (C) 2016 Robert Winslow Dalpe

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
		xmlns:trpg="http://rwdalpe.github.io/docbook/xslt/rpg/extension"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:exsl="http://exslt.org/common"

		exclude-result-prefixes="xsl db rpg h exsl trpg">

	<xsl:template name="trpg:gentext-container-span">
		<xsl:param name="key"/>
		<xsl:param name="contents"/>

		<span class="{$key}-container">
			<span class="{$key}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
							name="key"
							select="$key"/>
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<span class="{$key}-body">
				<xsl:copy-of select="$contents"/>
			</span>
		</span>
	</xsl:template>

	<xsl:template name="trpg:gentext-container-div">
		<xsl:param name="key"/>
		<xsl:param name="contents"/>

		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{$key}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
							name="key"
							select="$key"/>
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<span class="{$key}-body">
				<xsl:copy-of select="$contents"/>
			</span>
		</div>
	</xsl:template>

	<xsl:template name="trpg:named-container-div">
		<xsl:param name="name"/>
		<xsl:param name="contents" as="node()*"/>

		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{translate($name, ' ','')}-title">
				<xsl:value-of select="$name"/>
			</span>
			<xsl:text> </xsl:text>
			<span class="{translate($name, ' ','')}-body">
				<xsl:copy-of select="$contents"/>
			</span>
		</div>
	</xsl:template>

	<xsl:template name="trpg:everything-xlink-content">
		<xsl:for-each select="./node()">
			<xsl:call-template name="trpg:text-or-inline"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="trpg:no-qualifier-xlink-content">
		<xsl:for-each select="./node()[not(self::rpg:qualifier)]">
			<xsl:call-template name="trpg:text-or-inline"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="trpg:text-or-inline">
		<xsl:choose>
			<xsl:when test="self::text()">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="inline.charseq"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>