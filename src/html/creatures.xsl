<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2015 Robert Winslow Dalpe

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
	xmlns:f="http://docbook.org/xslt/ns/extension"
	xmlns:rpg="http://docbook.org/ns/docbook"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:t="http://docbook.org/xslt/ns/template"

	exclude-result-prefixes="xsl db f rpg h xs t">

  <xsl:template match="*" mode="creature">
  	<xsl:apply-templates select="."/>
  </xsl:template>

	<xsl:template match="rpg:abbrevcreaturedesc" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:abbrevcreaturedesc[@style = 'compact']" mode="creature">
		<span class="{@style}">
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="rpg:abbrevcreature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" mode="creature" />
			</div>
			<xsl:apply-templates
				select="./rpg:abbrevcreaturedesc[not(@style) or @style != 'compact']" mode="creature"/>

			<xsl:variable
				name="compactDesc"
				select="./rpg:abbrevcreaturedesc[@style = 'compact']"/>
			<xsl:choose>
				<xsl:when test="$compactDesc">
					<div class="compactHPDesc-container">
						<xsl:apply-templates select="./rpg:hp" mode="creature"/>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="./rpg:abbrevcreaturedesc[@style = 'compact']" mode="creature"/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="./rpg:hp" mode="creature"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" mode="creature"/>
			</div>
			<xsl:apply-templates select="./rpg:xpreward" mode="creature"/>
			<div class="{local-name(.)}-raceClassLevels">
				<xsl:for-each select="./rpg:race">
					<xsl:apply-templates select="." mode="creature"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="./rpg:class">
					<xsl:apply-templates select="." mode="creature"/>
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-alignmentSizeTypes">
				<xsl:for-each select="./rpg:alignment | ./rpg:size | ./rpg:creaturetypes">
					<xsl:apply-templates select="." mode="creature"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-initSenses">
				<xsl:apply-templates select="./rpg:initiative" mode="creature"/>
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:senses" mode="creature"/>
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
				<xsl:apply-templates select="./rpg:aura" mode="creature"/>
			</div>
			<xsl:apply-templates select="./rpg:defenses | ./rpg:offenses" mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:resistance" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::*[self::rpg:resistance]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:immunity" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::*[self::rpg:immunity]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:dr" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::*[self::rpg:dr]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:defensiveability" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::*[self::rpg:defensiveability]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-container">
				<span class="{local-name(.)}-title">
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="local-name(.)" />
					</xsl:call-template>
				</span>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:defensiveability" mode="creature"/>
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
					<xsl:apply-templates select="./rpg:dr" mode="creature"/>
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
					<xsl:apply-templates select="./rpg:immunity" mode="creature"/>
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
					<xsl:apply-templates select="./rpg:resistance" mode="creature"/>
				</span>
			</xsl:if>
			<xsl:if test="./rpg:sr">
				<xsl:if test="./rpg:sr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates select="./rpg:sr" mode="creature"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creaturesaves/rpg:save" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::*[self::rpg:save]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creaturesaves" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:hp | rpg:abbrevcreature/rpg:hp" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:hpval" mode="creature"/>
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
					<xsl:apply-templates select="." mode="creature"/>
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:weaknesses/rpg:weakness" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::rpg:weakness">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:weaknesses" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<span class="{local-name(.)}-body">
				<xsl:apply-templates mode="creature"/>
			</span>
		</div>
	</xsl:template>

	<xsl:template match="rpg:defenses" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:defenses/rpg:ac" mode="creature">
		<div class="{local-name(.)}-container">
			<xsl:apply-templates select="."/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:meleeattacks | rpg:offenses/rpg:rangedattacks" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturespeeds/rpg:speed" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::rpg:speed">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturespeeds" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template
		match="rpg:creaturedimensions/rpg:space | rpg:creaturedimensions/rpg:reach" mode="creature">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
			<xsl:if test="following-sibling::rpg:*">
				<xsl:text>; </xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturedimensions" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:offenses" mode="creature">
		<div>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:senses" mode="creature">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:sense" mode="creature"/>
			<xsl:if test="./rpg:skill">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:skill" mode="creature"/>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template
		match="rpg:creature/rpg:challengerating | rpg:abbrevcreature/rpg:challengerating" mode="creature">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:xpreward" mode="creature">
		<div class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:initiative" mode="creature">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>

	<xsl:template match="rpg:creaturetypes" mode="creature">
		<span>
			<xsl:call-template name="common.html.attributes"/>
			<xsl:call-template name="id.attribute"/>
			<xsl:apply-templates select="./rpg:creaturetype" mode="creature"/>
			<xsl:if test="./rpg:creaturesubtype">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="./rpg:creaturesubtype" mode="creature"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>
</xsl:stylesheet>