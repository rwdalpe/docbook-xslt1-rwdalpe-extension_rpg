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

	<xsl:template
		match="rpg:alignment|rpg:location|rpg:settlementtype
														|rpg:government|rpg:settlementquality|rpg:settlementdisadvantage
														|rpg:creaturename | rpg:challengerating | rpg:xpreward
														| rpg:race | rpg:size | rpg:creaturetype | rpg:rating | rpg:hpval
														| rpg:defensiveability | rpg:immunity | rpg:weakness | rpg:damage | rpg:hiteffect
														| rpg:attackname">
		<xsl:call-template name="inline.charseq" />
	</xsl:template>

	<xsl:template match="rpg:attack/rpg:onhit">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:variable name="forXLink">
				<xsl:text>(</xsl:text>
				<xsl:apply-templates />
				<xsl:text>)</xsl:text>
			</xsl:variable>
			<xsl:call-template name="simple.xlink">
				<xsl:with-param
					name="content"
					select="$forXLink" />
			</xsl:call-template>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:space | rpg:reach">
		<xsl:variable name="forXlink">
			<xsl:for-each select="./node()[not(self::rpg:qualifier)]">
				<xsl:choose>
					<xsl:when test="self::text()">
						<xsl:copy-of select="." />
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="inline.charseq" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="simple.xlink">
			<xsl:with-param
				name="content"
				select="$forXlink" />
		</xsl:call-template>
		<xsl:if test="./rpg:qualifier">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:qualifier" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:attackbonus">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:variable
					name="mod"
					select="@modifier" />
				<xsl:call-template name="simple.xlink">
					<xsl:with-param
						name="content"
						select="string($mod)" />
				</xsl:call-template>
			</fo:inline>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::rpg:attackbonus]">
				<xsl:text>/</xsl:text>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:attack">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:variable
				name="stopAtPosition"
				select="count(./rpg:attackbonus[1]/preceding-sibling::node())" />
			<xsl:variable name="forXlink">
				<xsl:for-each
					select="./node()[count(preceding-sibling::node()) &lt;= $stopAtPosition]">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:copy-of select="." />
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="inline.charseq" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="simple.xlink">
				<xsl:with-param
					name="content"
					select="$forXlink" />
			</xsl:call-template>
			<xsl:apply-templates select="./rpg:attackbonus" />
			<xsl:if test="./rpg:qualifier[preceding-sibling::*[1][self::rpg:attackbonus]]">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier[1]" />
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:onhit" />
			<xsl:if test="./rpg:qualifier[preceding-sibling::rpg:onhit]">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier[2]" />
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:speed">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()[not(self::rpg:qualifier)]">
						<xsl:choose>
							<xsl:when test="self::text()">
								<xsl:copy-of select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="inline.charseq" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="simple.xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</fo:inline>
			<xsl:if test="@rate">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:value-of select="@rate" />
				</fo:inline>
			</xsl:if>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:sr">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:inline>
			<xsl:text> </xsl:text>
			<fo:inline >
				<xsl:value-of select="@amount" />
			</fo:inline>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:resistance">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:value-of select="@amount" />
			</fo:inline>
			<xsl:text> </xsl:text>
			<fo:inline >
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()">
						<xsl:choose>
							<xsl:when test="self::text()">
								<xsl:copy-of select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="inline.charseq" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="simple.xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</fo:inline>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:dr">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:value-of select="@amount" />
			</fo:inline>
			<fo:inline >
				<xsl:text>/</xsl:text>
				<xsl:choose>
					<xsl:when test="./node()">
						<xsl:variable name="forXlink">
							<xsl:for-each select="./node()">
								<xsl:choose>
									<xsl:when test="self::text()">
										<xsl:copy-of select="." />
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="inline.charseq" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:call-template name="simple.xlink">
							<xsl:with-param
								name="content"
								select="$forXlink" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#8212;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:save">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()[not(self::rpg:qualifier)]">
						<xsl:choose>
							<xsl:when test="self::text()">
								<xsl:copy-of select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="inline.charseq" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="simple.xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</fo:inline>
			<xsl:if test="@modifier">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:value-of select="@modifier" />
				</fo:inline>
			</xsl:if>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:touch | rpg:flatfoot | rpg:fasthealing | rpg:regeneration">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:variable name="forXlink">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:apply-templates />
			</xsl:variable>
			<xsl:call-template name="simple.xlink">
				<xsl:with-param
					name="content"
					select="$forXlink" />
			</xsl:call-template>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:hp">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates select="./rpg:hpval" />
			<xsl:text> </xsl:text>
			<fo:inline >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:inline>
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
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:ac">
		<xsl:variable
			name="hasTouch"
			select="./rpg:touch" />
		<xsl:variable
			name="hasFlatFoot"
			select="./rpg:flatfoot" />

		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</fo:inline>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:rating" />
			<xsl:if test="$hasTouch">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="./rpg:touch" />
			</xsl:if>
			<xsl:if test="$hasFlatFoot">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="./rpg:flatfoot" />
			</xsl:if>

			<xsl:variable
				name="body"
				select="./node()[not(self::rpg:modifier) and not(self::rpg:rating) and not(self::rpg:touch) and not(self::rpg:flatfoot)]" />

			<xsl:if test="$body">
				<fo:inline >
					<xsl:variable name="forXlink">
						<xsl:for-each select="$body">
							<xsl:choose>
								<xsl:when test="self::text()">
									<xsl:copy-of select="." />
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="inline.charseq" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					<xsl:call-template name="simple.xlink">
						<xsl:with-param
							name="content"
							select="$forXlink" />
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</fo:inline>
			</xsl:if>

			<xsl:if test="./rpg:modifier">
				<xsl:text>(</xsl:text>
				<xsl:apply-templates select="./rpg:modifier">
					<xsl:with-param name="separator" select="', '"/>
				</xsl:apply-templates>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:modifier">
		<xsl:param
			name="separator"
			select="''" />

		<xsl:variable
			name="body"
			select="./node()[not(self::rpg:qualifier)]" />

		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:if test="$body">
				<fo:inline >
					<xsl:variable name="forXlink">
						<xsl:for-each select="$body">
							<xsl:choose>
								<xsl:when test="self::text()">
									<xsl:copy-of select="." />
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="inline.charseq" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					<xsl:call-template name="simple.xlink">
						<xsl:with-param
							name="content"
							select="$forXlink" />
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</fo:inline>
			</xsl:if>
			<fo:inline >
				<xsl:value-of select="@value" />
			</fo:inline>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</fo:wrapper>
		<xsl:if test="following-sibling::*[1][self::rpg:modifier]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:dc">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:call-template name="gentext">
				<xsl:with-param
					name="key"
					select="local-name(.)" />
			</xsl:call-template>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@rating" />
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:aura">
		<xsl:param
			name="separator"
			select="''" />

		<xsl:variable
			name="details"
			select="@range | ./rpg:dc"/>

		<xsl:variable
			name="context"
			select="." />

		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()[not(self::rpg:dc)]">
						<xsl:choose>
							<xsl:when test="self::text()">
								<xsl:copy-of select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="inline.charseq" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="simple.xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</fo:inline>
			<xsl:if test="$details">
				<xsl:text> (</xsl:text>
				<xsl:for-each select="$details">
					<xsl:if test="position() > 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<fo:inline >
						<xsl:choose>
							<xsl:when test="self::*">
								<xsl:apply-templates select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="." />
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</fo:wrapper>
		<xsl:if test="following-sibling::*[1][self::rpg:aura]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:skill">
		<xsl:param
			name="separator" select="''" />

		<xsl:variable
			name="hasModifier"
			select="@modifier" />

		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()[not(self::rpg:qualifier)]">
						<xsl:choose>
							<xsl:when test="self::text()">
								<xsl:copy-of select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="inline.charseq" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="simple.xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</fo:inline>
			<xsl:if test="$hasModifier">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:value-of select="@modifier" />
				</fo:inline>
			</xsl:if>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</fo:wrapper>
		<xsl:if test="following-sibling::*[1][self::rpg:skill]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:qualifier">
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:text>(</xsl:text>
			<xsl:call-template name="inline.charseq" />
			<xsl:text>)</xsl:text>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:sense">
		<xsl:param
			name="separator" select="''" />

		<xsl:variable
			name="hasRange"
			select="@range" />

		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:call-template name="inline.charseq" />
			</fo:inline>
			<xsl:if test="$hasRange">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:value-of select="@range" />
				</fo:inline>
			</xsl:if>
		</fo:wrapper>
		<xsl:if test="following-sibling::*[1][self::rpg:sense]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creaturesubtype">
		<xsl:param
			name="separator"
			select="''" />

		<xsl:call-template name="inline.charseq" />
		<xsl:if test="following-sibling::*[1][self::rpg:creaturesubtype]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:initiative">
		<xsl:variable
			name="hasBody"
			select="./text()|./*" />
		<xsl:variable
			name="hasMod"
			select="@modifier" />
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:if test="$hasBody">
				<fo:inline >
					<xsl:call-template name="inline.charseq" />
				</fo:inline>
			</xsl:if>
			<xsl:if test="$hasMod">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:choose>
						<xsl:when test="$hasBody">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="@modifier" />
							<xsl:text>)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@modifier" />
						</xsl:otherwise>
					</xsl:choose>
				</fo:inline>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:class">
		<xsl:param
			name="separator" select="''" />
		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:call-template name="inline.charseq" />
			<xsl:if test="@level">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:value-of select="@level" />
				</fo:inline>
			</xsl:if>
		</fo:wrapper>
		<xsl:if test="following-sibling::*[1][self::rpg:class]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:settlementdanger">
		<xsl:param
			name="prependSpace" select="false()"/>
		<xsl:variable
			name="hasMod"
			select="./@modifier" />
		<xsl:variable
			name="hasBody"
			select="./* | ./text()" />

		<fo:wrapper >
			<xsl:if test="$hasBody">
				<xsl:if test="$prependSpace">
					<xsl:text> </xsl:text>
				</xsl:if>
				<fo:inline >
					<xsl:call-template name="inline.charseq" />
				</fo:inline>
			</xsl:if>
			<xsl:if test="$hasMod">
				<xsl:if test="$prependSpace or $hasBody">
					<xsl:text> </xsl:text>
				</xsl:if>
				<fo:inline >
					<xsl:choose>
						<xsl:when test="$hasBody">
							(
							<xsl:value-of select="@modifier" />
							)
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@modifier" />
						</xsl:otherwise>
					</xsl:choose>
				</fo:inline>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:population">
		<xsl:variable
			name="hasCount"
			select="@count" />
		<xsl:variable
			name="hasBody"
			select="./* | ./text()" />

		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<xsl:if test="$hasCount">
				<fo:inline >
					<xsl:value-of select="@count" />
				</fo:inline>
			</xsl:if>
			<xsl:if test="$hasBody">
				<xsl:if test="$hasCount">
					<xsl:text> </xsl:text>
				</xsl:if>
				<fo:inline >
					<xsl:call-template name="inline.charseq" />
				</fo:inline>
			</xsl:if>
		</fo:wrapper>
	</xsl:template>

	<xsl:template match="rpg:abilityscore">
		<xsl:param
			name="separator" select="''" />

		<xsl:variable
			name="hasScore"
			select="@score" />
		<xsl:variable
			name="hasMod"
			select="@modifier" />

		<fo:wrapper>
			<xsl:call-template name="anchor"/>
			<fo:inline >
				<xsl:call-template name="inline.charseq" />
			</fo:inline>
			<xsl:if test="$hasScore">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:value-of select="@score" />
				</fo:inline>
			</xsl:if>
			<xsl:if test="$hasMod">
				<xsl:text> </xsl:text>
				<fo:inline >
					<xsl:choose>
						<xsl:when test="$hasScore">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="@modifier" />
							<xsl:text>)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@modifier" />
						</xsl:otherwise>
					</xsl:choose>
				</fo:inline>
			</xsl:if>
		</fo:wrapper>
		<xsl:if test="following-sibling::*[1][self::rpg:abilityscore]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>