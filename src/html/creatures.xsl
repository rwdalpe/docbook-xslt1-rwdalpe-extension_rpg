<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2014 Robert Winslow Dalpe

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
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:db="http://docbook.org/ns/docbook"
	xmlns:f="http://docbook.org/xslt/ns/extension"
	xmlns:rpg="http://docbook.org/ns/docbook"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:t="http://docbook.org/xslt/ns/template"

	exclude-result-prefixes="xsl db f rpg h xs t">

	<xsl:template match="rpg:abbrevcreaturedesc">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="rpg:abbrevcreaturedesc[@style = 'compact']">
		<span class="{@style}">
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates />
		</span>
	</xsl:template>


	<xsl:template match="rpg:abbrevcreature">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" />
			</div>
			<xsl:apply-templates
				select="./rpg:abbrevcreaturedesc[not(@style) or @style != 'compact']" />

			<xsl:variable
				name="compactDesc"
				select="./rpg:abbrevcreaturedesc[@style = 'compact']" />
			<xsl:choose>
				<xsl:when test="$compactDesc">
					<div class="compactHPDesc-container">
						<xsl:apply-templates select="./rpg:hp" />
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="./rpg:abbrevcreaturedesc[@style = 'compact']" />
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="./rpg:hp" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" />
			</div>
			<xsl:apply-templates select="./rpg:xpreward" />
			<div class="{local-name(.)}-raceClassLevels">
				<xsl:for-each select="./rpg:race">
					<xsl:apply-templates select="." />
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="./rpg:class">
					<xsl:apply-templates select="." />
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-alignmentSizeTypes">
				<xsl:for-each select="./rpg:alignment | ./rpg:size | ./rpg:creaturetypes">
					<xsl:apply-templates select="." />
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-initSenses">
				<xsl:apply-templates select="./rpg:initiative" />
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:senses" />
			</div>
			<div class="{local-name(.)}-auras">
				<span class="aura-title">
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="'aura'" />
					</xsl:call-template>
				</span>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:aura" />
			</div>
			<xsl:apply-templates select="./rpg:defenses | ./rpg:offenses" />
		</div>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:resistance">
		<xsl:next-match />
		<xsl:if test="following-sibling::*[self::rpg:resistance]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:immunity">
		<xsl:next-match />
		<xsl:if test="following-sibling::*[self::rpg:immunity]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:dr">
		<xsl:next-match />
		<xsl:if test="following-sibling::*[self::rpg:dr]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:defensiveability">
		<xsl:next-match />
		<xsl:if test="following-sibling::*[self::rpg:defensiveability]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-container">
				<span class="{local-name(.)}-title">
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="local-name(.)" />
					</xsl:call-template>
				</span>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:defensiveability" />
			</span>
			<xsl:if test="./rpg:dr">
				<xsl:if test="./rpg:dr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<span class="dr-container">
					<span class="dr-title">
						<xsl:call-template name="gentext">
							<xsl:with-param
								name="key"
								select="'dr'" />
						</xsl:call-template>
					</span>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./rpg:dr" />
				</span>
			</xsl:if>
			<xsl:if test="./rpg:immunity">
				<xsl:if test="./rpg:immunity[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<span class="immunities-container">
					<span class="immunities-title">
						<xsl:call-template name="gentext">
							<xsl:with-param
								name="key"
								select="'immunity'" />
						</xsl:call-template>
					</span>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./rpg:immunity" />
				</span>
			</xsl:if>
			<xsl:if test="./rpg:resistance">
				<xsl:if test="./rpg:resistance[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<span class="resistance-container">
					<span class="resistance-title">
						<xsl:call-template name="gentext">
							<xsl:with-param
								name="key"
								select="'resistance'" />
						</xsl:call-template>
					</span>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./rpg:resistance" />
				</span>
			</xsl:if>
			<xsl:if test="./rpg:sr">
				<xsl:if test="./rpg:sr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates select="./rpg:sr" />
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creaturesaves/rpg:save">
		<xsl:next-match />
		<xsl:if test="following-sibling::*[self::rpg:save]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creaturesaves">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:hp | rpg:abbrevcreature/rpg:hp">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:hpval" />
			<xsl:if test="@hdtotal or @expanded">
				<xsl:text> (</xsl:text>
				<xsl:if test="@hdtotal">
					<xsl:value-of select="@hdtotal" />
					<xsl:text> </xsl:text>
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="'hd'" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="@hdtotal and @expanded">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:if test="@expanded">
					<xsl:value-of select="@expanded" />
				</xsl:if>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:if test="./rpg:fasthealing | ./rpg:regeneration">
				<xsl:text>; </xsl:text>
				<xsl:for-each select="./rpg:fasthealing | ./rpg:regeneration">
					<xsl:if test="position() != 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:apply-templates select="." />
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:weaknesses/rpg:weakness">
		<xsl:next-match />
		<xsl:if test="following-sibling::rpg:weakness">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:weaknesses">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<span class="{local-name(.)}-body">
				<xsl:apply-templates />
			</span>
		</div>
	</xsl:template>

	<xsl:template match="rpg:defenses">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="rpg:defenses/rpg:ac">
		<div class="{local-name(.)}-container">
			<xsl:next-match />
		</div>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:meleeattacks | rpg:offenses/rpg:rangedattacks">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturespeeds/rpg:speed">
		<xsl:next-match />
		<xsl:if test="following-sibling::rpg:speed">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturespeeds">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template
		match="rpg:creaturedimensions/rpg:space | rpg:creaturedimensions/rpg:reach">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:next-match />
			<xsl:if test="following-sibling::rpg:*">
				<xsl:text>; </xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturedimensions">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="rpg:offenses">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="rpg:senses">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:sense" />
			<xsl:if test="./rpg:skill">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:skill" />
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template
		match="rpg:creature/rpg:challengerating | rpg:abbrevcreature/rpg:challengerating">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:next-match />
		</span>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:xpreward">
		<div class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:next-match />
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:initiative">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:next-match />
		</span>
	</xsl:template>

	<xsl:template match="rpg:creaturetypes">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates select="./rpg:creaturetype" />
			<xsl:if test="./rpg:creaturesubtype">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="./rpg:creaturesubtype" />
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>
</xsl:stylesheet>