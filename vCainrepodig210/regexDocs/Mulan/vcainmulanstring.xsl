<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="3.0">
    
    <!-- Identity transform -->
    <xsl:mode on-no-match="shallow-copy"/>
    
   
    <xsl:template match="text()">
        
        <!-- match stage directions in brackets -->
        <xsl:analyze-string select="." regex="\[(.+?)\]" flags="s">
            
            <xsl:matching-substring>
                <stg>
                    <xsl:value-of select="regex-group(1)"/>
                </stg>
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <!-- match speaker name before colon -->
                <xsl:analyze-string select="." regex="^\s*([^:]+?):">
                    
                    <xsl:matching-substring>
                        <spk>
                            <xsl:value-of select="regex-group(1)"/>
                        </spk>
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                    
                </xsl:analyze-string>
                
            </xsl:non-matching-substring>
            
        </xsl:analyze-string>
        
    </xsl:template>
    
</xsl:stylesheet>