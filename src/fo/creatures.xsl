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
	xmlns:rpg="http://docbook.org/ns/docbook"
	xmlns="http://www.w3.org/1999/XSL/Format"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	exclude-result-prefixes="xsl db fo rpg">

  <xsl:template match="*" mode="creature">
  	<xsl:apply-templates select="."/>
  </xsl:template>

	<xsl:template match="rpg:abbrevcreaturedesc" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates mode="creature"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:abbrevcreaturedesc[@style = 'compact']" mode="creature">
		<fo:wrapper >
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates />
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:abbrevcreature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:block text-align-last="justify" border="thin solid black">
				<xsl:apply-templates select="./rpg:creaturename" mode="creature"/>
				<fo:leader leader-pattern="space" />
				<xsl:apply-templates select="./rpg:challengerating" mode="creature" />
			</fo:block>
			<xsl:apply-templates
				select="./rpg:abbrevcreaturedesc[not(@style) or @style != 'compact']" mode="creature"/>

			<xsl:variable
				name="compactDesc"
				select="./rpg:abbrevcreaturedesc[@style = 'compact']"/>
			<xsl:choose>
				<xsl:when test="$compactDesc">
					<fo:block >
						<xsl:apply-templates select="./rpg:hp" mode="creature"/>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="./rpg:abbrevcreaturedesc[@style = 'compact']" mode="creature"/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="./rpg:hp" mode="creature"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:block text-align-last="justify" border="thin solid black">
				<xsl:apply-templates select="./rpg:creaturename" mode="creature"/>
				<fo:leader leader-pattern="space" />
				<xsl:apply-templates select="./rpg:challengerating" mode="creature" />
			</fo:block>
			<xsl:apply-templates select="./rpg:xpreward" mode="creature"/>
			<fo:block >
				<xsl:for-each select="./rpg:race">
					<xsl:apply-templates select="." mode="creature"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="./rpg:class">
					<xsl:apply-templates select="." mode="creature"/>
				</xsl:for-each>
			</fo:block>
			<fo:block >
				<xsl:for-each select="./rpg:alignment | ./rpg:size | ./rpg:creaturetypes">
					<xsl:apply-templates select="." mode="creature"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</fo:block>
			<fo:block >
				<xsl:apply-templates select="./rpg:initiative" mode="creature"/>
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:senses" mode="creature"/>
			</fo:block>
			<fo:block >
				<fo:wrapper >
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="'aura'" />
					</xsl:call-template>
				</fo:wrapper>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:aura" mode="creature"/>
			</fo:block>
			<xsl:apply-templates select="./rpg:defenses | ./rpg:offenses" mode="creature"/>
		</fo:block>
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
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<fo:inline >
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="local-name(.)" />
					</xsl:call-template>
				</fo:inline>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:defensiveability" mode="creature"/>
			</fo:wrapper>
			<xsl:if test="./rpg:dr">
				<xsl:if test="./rpg:dr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<fo:wrapper >
					<fo:inline >
						<xsl:call-template name="gentext">
							<xsl:with-param
								name="key"
								select="'dr'" />
						</xsl:call-template>
					</fo:inline>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./rpg:dr" mode="creature"/>
				</fo:wrapper>
			</xsl:if>
			<xsl:if test="./rpg:immunity">
				<xsl:if test="./rpg:immunity[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<fo:wrapper >
					<fo:inline >
						<xsl:call-template name="gentext">
							<xsl:with-param
								name="key"
								select="'immunity'" />
						</xsl:call-template>
					</fo:inline>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./rpg:immunity" mode="creature"/>
				</fo:wrapper>
			</xsl:if>
			<xsl:if test="./rpg:resistance">
				<xsl:if test="./rpg:resistance[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<fo:wrapper >
					<fo:inline >
						<xsl:call-template name="gentext">
							<xsl:with-param
								name="key"
								select="'resistance'" />
						</xsl:call-template>
					</fo:inline>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./rpg:resistance" mode="creature"/>
				</fo:wrapper>
			</xsl:if>
			<xsl:if test="./rpg:sr">
				<xsl:if test="./rpg:sr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates select="./rpg:sr" mode="creature"/>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:creaturesaves/rpg:save" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::*[self::rpg:save]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creaturesaves" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates mode="creature"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:hp | rpg:abbrevcreature/rpg:hp" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
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
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:weaknesses/rpg:weakness" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::rpg:weakness">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:weaknesses" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
			<xsl:text> </xsl:text>
			<fo:wrapper >
				<xsl:apply-templates mode="creature"/>
			</fo:wrapper>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:defenses" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:defenses/rpg:ac" mode="creature">
		<fo:block >
			<xsl:apply-templates select="."/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:meleeattacks | rpg:offenses/rpg:rangedattacks" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturespeeds/rpg:speed" mode="creature">
		<xsl:apply-templates select="."/>
		<xsl:if test="following-sibling::rpg:speed">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturespeeds" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</fo:block>
	</xsl:template>

	<xsl:template
		match="rpg:creaturedimensions/rpg:space | rpg:creaturedimensions/rpg:reach" mode="creature">
		<fo:wrapper >
			<fo:inline >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:inline>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
			<xsl:if test="following-sibling::rpg:*">
				<xsl:text>; </xsl:text>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:creaturedimensions" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:offenses" mode="creature">
		<fo:block>
			<xsl:call-template name="anchor"/>
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="creature"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:senses" mode="creature">
		<fo:wrapper >
			<fo:inline >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:inline>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:sense" mode="creature"/>
			<xsl:if test="./rpg:skill">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:skill" mode="creature"/>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template
		match="rpg:creature/rpg:challengerating | rpg:abbrevcreature/rpg:challengerating" mode="creature">
		<fo:wrapper >
			<fo:inline >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:inline>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:xpreward" mode="creature">
		<fo:block >
			<fo:wrapper >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:wrapper>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:initiative" mode="creature">
		<fo:wrapper >
			<fo:inline >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:inline>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="."/>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:creaturetypes" mode="creature">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates select="./rpg:creaturetype" mode="creature"/>
			<xsl:if test="./rpg:creaturesubtype">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="./rpg:creaturesubtype" mode="creature"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>
</xsl:stylesheet>