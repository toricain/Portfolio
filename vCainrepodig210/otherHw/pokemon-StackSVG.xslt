<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/2000/svg"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="xml-tree" as="document-node()"
        select="doc('pokemonMoves.xml')"/>
    
    <xsl:variable name="chartHeight" as="xs:integer" select="600"/>
    <xsl:variable name="barWidth" as="xs:integer" select="60"/>
    <xsl:variable name="labelLineHeight" as="xs:integer" select="18"/>
    
    <xsl:template match="/">
        <svg viewBox="0 0 500 760">
            
            <text x="250" y="30"
                text-anchor="middle"
                font-size="20"
                font-weight="bold">
                Pokemon Moves by Category
            </text>
            
            <g transform="translate(100 700)">
                <xsl:variable name="allCategories"
                    select="$xml-tree//category ! lower-case(.)"/>
                <xsl:variable name="distinctCategories"
                    select="$allCategories => distinct-values()"/>
                <xsl:variable name="sortedCategories" as="xs:string+">
                    <xsl:for-each select="$distinctCategories">
                        <xsl:sort
                            select="$xml-tree//move[lower-case(category)=current()] => count()"
                            order="descending"/>
                        <xsl:value-of select="current()"/>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:variable name="totalMoves"
                    select="$xml-tree//move => count()"/>
                <xsl:for-each select="$sortedCategories">
                    
                    <xsl:variable name="cat" select="current()"/>
                    <xsl:variable name="positionInStack" select="position()"/>
                    
                    <xsl:variable name="countHere"
                        select="$xml-tree//move[lower-case(category) = $cat] => count()"/>
                    
                    <xsl:variable name="segmentHeight"
                        select="$countHere div $totalMoves * $chartHeight"/>
                    <xsl:variable name="previousCounts" as="xs:double+">
                        <xsl:choose>
                            <xsl:when test="$positionInStack gt 1">
                                <xsl:for-each
                                    select="$sortedCategories[position() lt $positionInStack]">
                                    <xsl:value-of
                                        select="
                                        ($xml-tree//move[lower-case(category)=current()] => count())
                                        div $totalMoves * $chartHeight
                                        "/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="0"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="yOffset"
                        select="sum($previousCounts)"/>
                    <xsl:variable name="color" select="
                        if ($cat='fire') then '#EE8130'
                        else if ($cat='water') then '#6390F0'
                        else if ($cat='grass') then '#7AC74C'
                        else if ($cat='electric') then '#F7D02C'
                        else if ($cat='ice') then '#96D9D6'
                        else if ($cat='fighting') then '#C22E28'
                        else if ($cat='poison') then '#A33EA1'
                        else if ($cat='ground') then '#E2BF65'
                        else if ($cat='flying') then '#A98FF3'
                        else if ($cat='psychic') then '#F95587'
                        else if ($cat='bug') then '#A6B91A'
                        else if ($cat='rock') then '#B6A136'
                        else if ($cat='ghost') then '#735797'
                        else if ($cat='dragon') then '#6F35FC'
                        else if ($cat='dark') then '#705746'
                        else if ($cat='steel') then '#B7B7CE'
                        else if ($cat='fairy') then '#D685AD'
                        else '#A8A77A'
                        "/>

                    <rect
                        x="0"
                        y="-{$yOffset + $segmentHeight}"
                        width="{$barWidth}"
                        height="{$segmentHeight}"
                        fill="{$color}"/>

                    <text
                        x="100"
                        y="{position() * $labelLineHeight - 650}"
                        font-size="12">
                        <xsl:value-of select="$cat"/>:
                        <xsl:value-of select="$countHere"/>
                    </text>
                    
                </xsl:for-each>
                
            </g>
        </svg>
    </xsl:template>
    
</xsl:stylesheet>