<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2016 Robert Winslow Dalpe

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as published
	by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>
-->
<xsl:stylesheet
		version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:rpg="http://docbook.org/ns/docbook"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:trpg="http://rwdalpe.github.io/docbook/xslt/rpg/extension"

		exclude-result-prefixes="xsl db rpg h xs trpg">

	<xsl:template
			match="*"
			mode="creature">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="rpg:abbrevcreature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" mode="creature"/>
			</div>
			<xsl:apply-templates select="./*[not(self::rpg:creaturename or self::rpg:challengerating)]"
					mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<div class="{local-name(.)}-header">
				<xsl:apply-templates
						select="./rpg:creaturename|./rpg:challengerating"
						mode="creature"/>
			</div>
			<xsl:apply-templates
					select="./rpg:xpreward"
					mode="creature"/>
			<div class="{local-name(.)}-raceClassLevels">
				<xsl:for-each select="./rpg:race">
					<xsl:apply-templates
							select="."
							mode="creature"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="./rpg:class">
					<xsl:apply-templates select="." mode="creature">
						<xsl:with-param name="separator" select="'/'"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-alignmentSizeTypes">
				<xsl:for-each select="./rpg:alignment | ./rpg:size | ./rpg:creaturetypes">
					<xsl:apply-templates
							select="."
							mode="creature"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-initSenses">
				<xsl:apply-templates
						select="./rpg:initiative"
						mode="creature"/>
				<xsl:text>; </xsl:text>
				<xsl:apply-templates
						select="./rpg:senses"
						mode="creature"/>
			</div>
			<xsl:if test="./rpg:aura">
				<xsl:call-template name="trpg:named-container-div">
					<xsl:with-param name="name">
						<xsl:call-template name="gentext">
							<xsl:with-param
									name="key"
									select="'aura'"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="contents">
						<xsl:apply-templates select="./rpg:aura" mode="creature">
							<xsl:with-param name="separator" select="', '"/>
						</xsl:apply-templates>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:apply-templates
					select="./rpg:defenses | ./rpg:offenses | ./rpg:statistics | ./rpg:statblocksection"
					mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:resistance
		| rpg:defensiveabilities/rpg:immunity
		| rpg:defensiveabilities/rpg:dr
		| rpg:defensiveabilities/rpg:defensiveability
		| rpg:creaturesaves/rpg:save
		| rpg:defenses/rpg:weaknesses/rpg:weakness
		| rpg:offenses/rpg:creaturespeeds/rpg:speed
		| rpg:offenses/rpg:specialattacks/rpg:specialattack
		| rpg:slatier/rpg:sla
		| rpg:spelltier/rpg:spell
		| rpg:creaturefeats/rpg:feat
		| rpg:creatureskills/rpg:skill"

			mode="creature">

		<xsl:variable name="localName" select="local-name(.)"/>
		<xsl:variable name="nsUri" select="namespace-uri(.)"/>
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::*[1][namespace-uri(.) = $nsUri and local-name(.) = $localName]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template
			match="rpg:defensiveabilities"
			mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:call-template name="trpg:gentext-container-span">
				<xsl:with-param name="key" select="local-name(.)"/>
				<xsl:with-param name="contents">
					<xsl:apply-templates
							select="./rpg:defensiveability"
							mode="creature"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./rpg:dr">
				<xsl:if test="./rpg:dr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:call-template name="trpg:gentext-container-span">
					<xsl:with-param name="key" select="'dr'"/>
					<xsl:with-param name="contents">
						<xsl:apply-templates
								select="./rpg:dr"
								mode="creature"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="./rpg:immunity">
				<xsl:if test="./rpg:immunity[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:call-template name="trpg:gentext-container-span">
					<xsl:with-param name="key" select="'immunity'"/>
					<xsl:with-param name="contents">
						<xsl:apply-templates
								select="./rpg:immunity"
								mode="creature"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="./rpg:resistance">
				<xsl:if test="./rpg:resistance[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:call-template name="trpg:gentext-container-span">
					<xsl:with-param name="key" select="'resistance'"/>
					<xsl:with-param name="contents">
						<xsl:apply-templates
								select="./rpg:resistance"
								mode="creature"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="./rpg:sr">
				<xsl:if test="./rpg:sr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates
						select="./rpg:sr"
						mode="creature"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template
			match="rpg:creaturesaves"
			mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:hp | rpg:abbrevcreature/rpg:statblocksection/rpg:hp"
			mode="creature">
		<xsl:call-template name="trpg:gentext-container-div">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates
						select="./rpg:hpval"
						mode="creature"/>
				<xsl:if test="@hdtotal or @expanded">
					<xsl:text> (</xsl:text>
					<xsl:if test="@hdtotal">
						<xsl:value-of select="@hdtotal"/>
						<xsl:text> </xsl:text>
						<xsl:call-template name="gentext">
							<xsl:with-param
									name="key"
									select="'hd'"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="@hdtotal and @expanded">
						<xsl:text>; </xsl:text>
					</xsl:if>
					<xsl:if test="@expanded">
						<xsl:value-of select="@expanded"/>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="./rpg:fasthealing | ./rpg:regeneration">
					<xsl:text>; </xsl:text>
					<xsl:for-each select="./rpg:fasthealing | ./rpg:regeneration">
						<xsl:if test="position() != 1">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:apply-templates
								select="."
								mode="creature"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:defenses
		| rpg:offenses
		| rpg:creature/rpg:defenses/rpg:weaknesses
		| rpg:offenses/rpg:meleeattacks | rpg:offenses/rpg:rangedattacks
		| rpg:offenses/rpg:creaturespeeds
		| rpg:offenses/rpg:creaturedimensions
		| rpg:offenses/rpg:specialattacks
		| rpg:statistics
		| rpg:statistics/rpg:creaturefeats | rpg:statistics/rpg:creatureskills"

			mode="creature">
		<xsl:call-template name="trpg:gentext-container-div">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates mode="creature"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template
			match="rpg:creaturedimensions/rpg:space | rpg:creaturedimensions/rpg:reach"
			mode="creature">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates select="."/>
				<xsl:if test="following-sibling::rpg:*">
					<xsl:text>; </xsl:text>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template
			match="rpg:senses"
			mode="creature">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates select="./rpg:sense" mode="creature">
					<xsl:with-param name="separator" select="', '"/>
				</xsl:apply-templates>
				<xsl:if test="./rpg:skill">
					<xsl:if test="count(./rpg:sense) > 0">
						<xsl:text>; </xsl:text>
					</xsl:if>
					<xsl:apply-templates select="./rpg:skill" mode="creature">
						<xsl:with-param name="separator" select="', '"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:challengerating | rpg:abbrevcreature/rpg:challengerating
		| rpg:creature/rpg:initiative
		| rpg:attackstatistics/rpg:bab | rpg:attackstatistics/rpg:cmb | rpg:attackstatistics/rpg:cmd"

			mode="creature">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates select="."/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template
			match="rpg:creature/rpg:xpreward | rpg:abbrevcreature/rpg:xpreward"
			mode="creature">
		<xsl:call-template name="trpg:gentext-container-div">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates select="."/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template
			match="rpg:creaturetypes"
			mode="creature">
		<span>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:apply-templates
					select="./rpg:creaturetype"
					mode="creature"/>
			<xsl:if test="./rpg:creaturesubtype">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="./rpg:creaturesubtype" mode="creature">
					<xsl:with-param name="separator" select="', '"/>
				</xsl:apply-templates>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:slas | rpg:offenses/rpg:spellsprepped" mode="creature">
		<xsl:variable name="titleOverride">
			<xsl:choose>
				<xsl:when test="@title">
					<xsl:value-of select="@title"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="contents">
			<span class="{local-name(.)}-clConcentration">
				<xsl:text>(</xsl:text>
				<xsl:variable name="clAndCon" select="./rpg:casterlevel and ./rpg:concentration"/>
				<xsl:apply-templates select="./rpg:casterlevel" mode="creature"/>
				<xsl:if test="$clAndCon">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates select="./rpg:concentration" mode="creature"/>
				<xsl:text>)</xsl:text>
			</span>
			<ul class="{local-name(.)}">
				<xsl:apply-templates select="./rpg:slatier | ./rpg:spelltier" mode="creature"/>
			</ul>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$titleOverride != ''">
				<xsl:call-template name="trpg:named-container-div">
					<xsl:with-param name="name" select="$titleOverride"/>
					<xsl:with-param name="contents" select="$contents"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="trpg:gentext-container-div">
					<xsl:with-param name="key" select="local-name(.)"/>
					<xsl:with-param name="contents" select="$contents"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:slas/rpg:slatier | rpg:offenses/rpg:spellsprepped/rpg:spelltier"
			mode="creature">
		<li>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-frequency">
				<xsl:value-of select="@frequency | @tiername"/>
			</span>
			<xsl:text> &#x2014; </xsl:text>
			<span class="{local-name(.)}-body">
				<xsl:apply-templates mode="creature"/>
			</span>
		</li>
	</xsl:template>

	<xsl:template match="rpg:statistics/rpg:abilityscores" mode="creature">
		<xsl:apply-templates select=".">
			<xsl:with-param name="separator" select="', '"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="rpg:statistics/rpg:attackstatistics" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:apply-templates select="./rpg:bab" mode="creature"/>
			<xsl:for-each select="./rpg:cmb | rpg:cmd">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="." mode="creature"/>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>