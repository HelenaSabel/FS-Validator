<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="apos">&apos;</xsl:variable>
    <xsl:variable name="boundary">&apos;, &apos;</xsl:variable>
    <xsl:template match="/">
        <xsl:result-document href="methal_personography.odd">
            <TEI xml:lang="en" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
                <?TEIVERSION Version 4.3.0. Last updated on
        31st August 2021, revision b4f72b1ff?>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>TEI MeThAL personography</title>
                            <author>Pablo Ruiz Fabo</author>
                            <author>Helena Bermúdez Sabel</author>
                        </titleStmt>
                        <publicationStmt>
                            <publisher>LiLPa - Université de Strasbourg</publisher>
                            <publisher>MeThAL project</publisher>
                            <availability status="free">
                                <licence target="http://creativecommons.org/licenses/by-nc/4.0/"
                                    >Creative Commons BY-NC</licence>
                            </availability>
                        </publicationStmt>
                        <notesStmt>
                            <note type="ns">https://methal.eu</note>
                        </notesStmt>
                        <sourceDesc>
                            <p>Written from scratch.</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <head>TEI for MeThAL project personography</head>
                        <schemaSpec ident="tei_methal_personography">
                            <moduleRef n="01" key="tei"/>
                            <moduleRef n="02" key="header"/>
                            <moduleRef n="03" key="core"/>
                            <moduleRef n="04" key="textstructure"/>
                            <moduleRef n="17" key="analysis"/>
                            <moduleRef n="10" key="msdescription"/>
                            <moduleRef n="11" key="transcr"/>
                            <moduleRef n="13" key="namesdates"/>
                            <moduleRef n="16" key="linking"/>
                            <moduleRef n="18" key="iso-fs"/>
                            <moduleRef n="21" key="certainty"/>
                            <moduleRef n="22" key="tagdocs"/>
                            <elementSpec ident="fs" module="iso-fs" mode="change">
                                <constraintSpec scheme="schematron" ident="fs_constraints">
                                    <desc>Schematron constraints created from processing the Feature
                                        System declaration</desc>
                                    <constraint>
                                        <xsl:apply-templates select="//fsDecl"/>
                                    </constraint>
                                </constraintSpec>
                            </elementSpec>
                            <elementSpec ident="f" module="iso-fs" mode="change">
                                <constraintSpec scheme="schematron" ident="f_constraints">
                                    <desc>Schematron constraints created from processing the Feature
                                        System declaration</desc>
                                    <constraint>
                                        <xsl:apply-templates select="//fDecl"/>
                                    </constraint>
                                </constraintSpec>
                            </elementSpec>
                        </schemaSpec>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="fsDecl">
        <xsl:variable name="names-obl">
            <xsl:value-of select="string-join(fDecl[@optional eq 'false']/@name, ', ')"/>
        </xsl:variable>
        <xsl:variable name="f-values-obl">
            <xsl:value-of select="replace($names-obl, ', ', $boundary)"/>
        </xsl:variable>
        <xsl:variable name="names-op">
            <xsl:value-of
                select="string-join(fDecl[@optional eq 'true' or not(@optional)]/@name, ', ')"/>
        </xsl:variable>
        <xsl:variable name="f-values-op">
            <xsl:value-of select="replace($names-op, ', ', $boundary)"/>
        </xsl:variable>
        <xsl:variable name="context"
            select="'tei:text/descendant::tei:fs[@type eq ' || $apos || current()/@type || $apos || ']'"/>
        <xsl:if test="fsConstraints">
            <xsl:for-each select="fsConstraints/cond">
                <xsl:variable name="condition" select="fs[following-sibling::then]/f"/>
                <xsl:variable name="then" select="fs[preceding-sibling::then]/f"/>
                <sch:rule>
                    <xsl:choose>
                        <xsl:when test="$condition[not(child::*)]">

                            <xsl:attribute name="context"
                                select="$context || '[tei:f[@name eq ' || $apos || $condition/@name || $apos || ']]'"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="context" select="
                                    $context || '[tei:f[@name eq ' || $apos || $condition/@name || $apos ||
                                    '][tei:' || $condition/*/name() || '[@' || $condition/*/name(@*) || ' eq ' || $apos || $condition/*/@* || $apos || ']]]'"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="$then">
                        <xsl:variable name="test"
                            select="'tei:f[@name eq ' || $apos || current()/@name || $apos || ']'"/>
                        <sch:assert>
                            <xsl:attribute name="test" select="$test"/>Missing <xsl:value-of
                                select="$test"/>
                        </sch:assert>
                        <xsl:if test="current()/vAlt">
                            <xsl:variable name="controlled_values" select="
                                    for $x in vAlt/symbol/@value
                                    return
                                        $apos || $x || $apos"/>
                            <sch:assert>
                                <xsl:attribute name="test"
                                    select="$test || '/tei:symbol/@value = (' || string-join($controlled_values, ','), ')'"
                                />Possible values of <xsl:value-of select="$test"/> are
                                    <xsl:value-of select="$controlled_values"/>
                            </sch:assert>
                        </xsl:if>


                    </xsl:for-each>
                </sch:rule>
            </xsl:for-each>
        </xsl:if>
        <sch:rule>
            <xsl:attribute name="context" select="$context"/>

            <xsl:if test="fDecl/@optional = 'false'">
                <xsl:for-each select="$names-obl">
                    <sch:assert>
                        <xsl:attribute name="test"
                            select="'tei:f/@name = ' || $apos || current() || $apos"/> The feature
                            <xsl:value-of select="current()"/> is mandatory </sch:assert>
                </xsl:for-each>
            </xsl:if>
            <xsl:if
                test="fDecl[(@optional = 'true') or not(@optional)] and not(fDecl/@optional = 'false')">
                <sch:report>
                    <xsl:attribute name="test">
                        <xsl:value-of
                            select="concat('tei:f[not(@name = (', $apos, $f-values-op, $apos, '))]')"
                        />
                    </xsl:attribute> Possible features: <xsl:value-of
                        select="concat($apos, $names-op, $apos)"/>
                </sch:report>
            </xsl:if>
            <xsl:if
                test="fDecl[(@optional = 'true') or not(@optional)] and fDecl/@optional = 'false'">
                <sch:assert>
                    <xsl:variable name="count-ob" select="count(fDecl[@optional = 'false'])"/>
                    <xsl:attribute name="test">
                        <xsl:value-of
                            select="concat('if (count(tei:f) gt ' || $count-ob || ') then tei:f[@name = (', $apos, $f-values-op, $apos, ')] else true()')"
                        />
                    </xsl:attribute> Possible features: <xsl:value-of
                        select="concat($apos, $names-op, $apos)"/>
                </sch:assert>
            </xsl:if>
        </sch:rule>
    </xsl:template>
    <xsl:template match="fDecl">
        <sch:rule>
            <xsl:attribute name="context">
                <xsl:value-of
                    select="concat('tei:text/descendant::tei:f[@name eq ', $apos, current()/@name, $apos, ']', '[parent::tei:fs[@type eq ', $apos, current()/parent::fsDecl/@type, $apos, ']]')"
                />
            </xsl:attribute>
            <xsl:if test="not(vDefault) and (vRange/binary or vRange/string)">
                <sch:assert>
                    <xsl:attribute name="test"><xsl:value-of select="'tei:' || vRange/*/name()"
                        /></xsl:attribute> Element <xsl:value-of select="vRange/*/name()"/> is
                    mandatory </sch:assert>
            </xsl:if>
            <xsl:if test="vDefault and (vRange/binary or vRange/string)">
                <sch:assert>
                    <xsl:attribute name="test"><xsl:value-of
                            select="'tei:default or tei:' || vRange/*/name()"/></xsl:attribute>
                    Element <xsl:value-of select="vRange/*/name()"/> or element default is mandatory
                </sch:assert>
            </xsl:if>
            <xsl:if test="vRange/vNot">
                <sch:assert>
                    <xsl:attribute name="test">tei:string/text()</xsl:attribute>
                    <xsl:text>This cannot be an empty element</xsl:text>
                </sch:assert>
            </xsl:if>
            <xsl:if test="vRange/vAlt/count(distinct-values(*/name())) = 1">
                <xsl:choose>
                    <xsl:when test="vRange/vAlt/binary">
                        <sch:assert>
                            <xsl:attribute name="test">tei:binary</xsl:attribute>
                            <xsl:text>Mandatory binary feature</xsl:text>
                        </sch:assert>
                    </xsl:when>
                    <xsl:otherwise>
                        <sch:report>
                            <xsl:attribute name="test">
                                <xsl:variable name="symbols">
                                    <xsl:value-of
                                        select="replace(string-join(./vRange/vAlt/symbol/@value, ','), ',', $boundary)"
                                    />
                                </xsl:variable>
                                <xsl:value-of
                                    select="concat('tei:symbol[not(@value = (', $apos, $symbols, $apos, '))]')"
                                />
                            </xsl:attribute> Incorrect value of @value. Possible values are:
                                <xsl:value-of
                                select="concat($apos, string-join(./vRange/vAlt/symbol/@value, ', '), $apos)"
                            />
                        </sch:report>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="vRange/vAlt/count(distinct-values(*/name())) = 2">
                <xsl:variable name="elements" select="vRange/vAlt/distinct-values(*/name())"/>
                <sch:assert>
                    <xsl:attribute name="test">
                        <xsl:value-of select="'tei:' || string-join($elements, ' or tei:')"/>
                    </xsl:attribute> This feature must have one of the following elements:
                        <xsl:value-of select="string-join($elements, ', ')"/>
                </sch:assert>
                <xsl:if test="vRange/vAlt/symbol">
                    <sch:report>
                        <xsl:variable name="symbols">
                            <xsl:value-of
                                select="replace(string-join(./vRange/vAlt/symbol/@value, ','), ',', $boundary)"
                            /></xsl:variable>
                        <xsl:attribute name="test">
                            <xsl:value-of
                                select="concat('tei:symbol[not(@value = (', $apos, $symbols, $apos, '))]')"
                            />
                        </xsl:attribute> Incorrect value of symbol. Possible values are:
                            <xsl:value-of
                            select="concat($apos, string-join(./vRange/vAlt/symbol/@value, ', '), $apos)"
                        /></sch:report>
                </xsl:if>


            </xsl:if>
            <xsl:if test="vRange/vColl/symbol">
                <xsl:variable name="symbolValues"
                    select="string-join(vRange/vColl/symbol/@value, $boundary)"/>
                <sch:report>
                    <xsl:attribute name="test"><xsl:value-of
                            select="'if (tei:symbol) then tei:symbol[not(@value = (' || $apos || $symbolValues || $apos || '))] else false()'"
                        /></xsl:attribute> Possible values of symbol/@value are: <xsl:value-of
                        select="$apos || $symbolValues || $apos"/>
                </sch:report>
                <sch:report>
                    <xsl:attribute name="test"><xsl:value-of
                            select="'if (tei:vColl/tei:symbol) then tei:vColl/tei:symbol[not(@value = (' || $apos || $symbolValues || $apos || '))] else false()'"
                        /></xsl:attribute> Possible values of symbol/@value are: <xsl:value-of
                        select="$apos || $symbolValues || $apos"/>
                </sch:report>
            </xsl:if>
            <xsl:if test="vRange/vColl/fs">
                <xsl:variable name="fsNames" select="string-join(vRange/vColl/fs/@type, $boundary)"/>
                <sch:report>
                    <xsl:attribute name="test"><xsl:value-of
                            select="'if (tei:vColl/tei:fs) then tei:vColl/tei:fs[not(@type = (' || $apos || $fsNames || $apos || '))] else false()'"
                        /></xsl:attribute> Possible values of fs/@type are: <xsl:value-of
                        select="$apos || $fsNames || $apos"/>
                </sch:report>
            </xsl:if>
            <xsl:if test="vRange/fs">
                <sch:report>
                    <xsl:attribute name="test"><xsl:value-of
                            select="'tei:fs[not(@type = (' || $apos || vRange/fs/@type || $apos || '))]'"
                        /></xsl:attribute> Mandatory fs of @type <xsl:value-of
                        select="vRange/fs/@type"/>
                </sch:report>
            </xsl:if>
        </sch:rule>

    </xsl:template>
</xsl:stylesheet>
