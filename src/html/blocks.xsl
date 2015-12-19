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
  exclude-result-prefixes="xsl db rpg h">

  <xsl:template match="rpg:abilityscores">
    <xsl:call-template name="block.object"/>
  </xsl:template>
</xsl:stylesheet>