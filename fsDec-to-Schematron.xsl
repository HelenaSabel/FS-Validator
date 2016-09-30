<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://purl.oclc.org/dsdl/schematron" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="apos">&apos;</xsl:variable>
    <xsl:variable name="boundary">&apos;, &apos;</xsl:variable>
    <xsl:template match="/">
        <xsl:element name="schema">
            <xsl:attribute name="queryBinding">xslt2</xsl:attribute>
            <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
            <pattern>
                <xsl:apply-templates select="//fsdDecl"/>
            </pattern>
        </xsl:element>
    </xsl:template>
    <xsl:template match="fsDecl[@type]">
        <xsl:variable name="optionalFeatures" select="fDecl[@optional eq 'true']/@name"/>
        <xsl:variable name="optionalFeaturesList"
            select="concat($apos, string-join($optionalFeatures, $boundary), $apos)"/>
        <xsl:variable name="mandatoryFeatures" select="fDecl[@optional eq 'false']/@name"/>
        <xsl:variable name="mandatoryFeaturesList"
            select="concat($apos, string-join($mandatoryFeatures, $boundary), $apos)"/>
        <xsl:variable name="countMandatory" select="count($mandatoryFeatures)"/>
        <xsl:element name="rule">
            <xsl:attribute name="context">
                <xsl:value-of
                    select="concat('tei:fs[@type eq ', $apos, current()/@type, $apos, ']')"/>
            </xsl:attribute>

            <!--Rule to check that the features used that are not declared as mandatory (that is, the optional ones) are indeed in the
            feature structure declaration -->

            <xsl:if test="count($optionalFeatures) gt 0">
                <xsl:element name="assert">
                    <xsl:attribute name="test">
                        <xsl:value-of
                            select="concat('if (count(./tei:f) gt ', $countMandatory, ') then tei:f[@name = (', $optionalFeaturesList, ')] else true()')"
                        />
                    </xsl:attribute> The mandatory features are <xsl:value-of
                        select="$mandatoryFeaturesList"/>; and the optional ones are <xsl:value-of
                        select="$optionalFeaturesList"/>. There is a feature in this structure that
                    has not been declared </xsl:element>
            </xsl:if>

            <!--Rule to check that the non-optional features are in the
            feature structure declaration -->

            <xsl:if test="count($mandatoryFeatures) gt 0">
                <xsl:for-each select="$mandatoryFeatures">
                    <xsl:element name="assert">
                        <xsl:attribute name="test">
                            <xsl:value-of
                                select="concat('tei:f[@name eq ', $apos, current(), $apos, ']')"/>
                        </xsl:attribute> The feature “<xsl:value-of select="current()"/>” is missing
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:element>
        <xsl:apply-templates select="fDecl"/>
    </xsl:template>
    <xsl:template match="fDecl">
        <xsl:element name="rule">
            <xsl:attribute name="context">
                <xsl:value-of
                    select="concat('tei:f[@name eq ', $apos, current()/@name, $apos, ']', '[parent::fs[@type eq ', $apos, current()/parent::fsDecl/@type, $apos, ']]')"
                />
            </xsl:attribute>

            <!-- I'm considering that the use of <vNot> followed by an empty element means
            that the element is mandatory (and that it must have content)-->

            <xsl:if test="vRange/vNot/*[not(*)]">
                <xsl:for-each select="vRange/vNot/*">
                    <xsl:element name="assert">
                        <xsl:attribute name="test">
                            <xsl:value-of select="concat('tei:', current()/name())"/>
                        </xsl:attribute> The element <xsl:value-of select="current()/name()"/> is
                        required </xsl:element>
                    <xsl:element name="report">
                        <xsl:attribute name="test"><xsl:value-of select="concat('tei:', current()/name(), '[not(*)]')"/>
                        </xsl:attribute>This feature must contain a <xsl:value-of select="current()/name()"/> element
                        with content
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="vRange/vAlt/count(distinct-values(*/name())) = 1">
                <xsl:choose>
                    <xsl:when test="vRange/vAlt/vNot">
                        <xsl:element name="assert">
                            <xsl:attribute name="test">tei:vAlt/tei:string/text()</xsl:attribute>
                            <xsl:text>This cannot be an empty element</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="vRange/vAlt/fs">
                        <xsl:element name="assert">
                            <xsl:attribute name="test">
                                <xsl:variable name="types">
                                    <xsl:value-of
                                        select="replace(string-join(./vRange/vAlt/fs/@type, '-'), '-', $boundary)"
                                    />
                                </xsl:variable>
                                <xsl:value-of
                                    select="concat('tei:fs[@type = (', $apos, $types, $apos, ')]')"
                                />
                            </xsl:attribute> Incorrect @type value. Possible values are:
                                <xsl:value-of
                                select="concat($apos, string-join(./vRange/vAlt/fs/@type, ', '), $apos)"
                            />
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="vRange/vAlt/binary">
                        <xsl:element name="assert">
                            <xsl:attribute name="test">tei:binary</xsl:attribute> Binary feature.
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="assert">
                            <xsl:attribute name="test">
                                <xsl:variable name="symbols">
                                    <xsl:value-of
                                        select="replace(string-join(./vRange/vAlt/symbol/@value, ','), ',', $boundary)"
                                    />
                                </xsl:variable>
                                <xsl:value-of
                                    select="concat('tei:symbol[@value = (', $apos, $symbols, $apos, ')]')"
                                />
                            </xsl:attribute> Incorrect @type value. Possible values are:
                                <xsl:value-of
                                select="concat($apos, string-join(./vRange/vAlt/symbol/@value, ', '), $apos)"
                            />
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="vRange/vAlt/count(distinct-values(*/name())) = 2">
                <xsl:element name="assert">
                    <xsl:attribute name="test">
                        <xsl:variable name="types">
                            <xsl:value-of
                                select="replace(string-join(./vRange/vAlt/fs/@type, ','), ',', $boundary)"
                            />
                        </xsl:variable>
                        <xsl:variable name="symbols">
                            <xsl:value-of
                                select="replace(string-join(./vRange/vAlt/symbol/@value, ','), ',', $boundary)"
                            />
                        </xsl:variable>
                        <xsl:value-of
                            select="concat('tei:symbol[@value = (', $apos, $symbols, $apos, ')] or tei:fs[@type = (', $apos, $types, $apos, ')]')"
                        />
                    </xsl:attribute> Incorrect value. Possible values are: a fs element with one of
                    the following @type attributes <xsl:value-of
                        select="concat($apos, string-join(./vRange/vAlt/fs/@type, ', '), $apos)"/>
                    or a symbol element with one of the following @value attributes <xsl:value-of
                        select="concat($apos, string-join(./vRange/vAlt/symbol/@value, ', '), $apos)"
                    />
                </xsl:element>
            </xsl:if>
            <xsl:if test="vRange/fs">
                <xsl:for-each select="vRange/fs">
                    <xsl:element name="assert">
                        <xsl:attribute name="test">
                            <xsl:value-of
                                select="concat('tei:fs[@name =', $apos, current(), $apos, ']')"
                            />
                        </xsl:attribute> Required fs of type <xsl:value-of
                            select="current()/@type"/>
                    </xsl:element>
                </xsl:for-each>
               
            </xsl:if>
        </xsl:element>

    </xsl:template>
</xsl:stylesheet>
