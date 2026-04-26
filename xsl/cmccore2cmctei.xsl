<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:t="http://www.tei-c.org/ns/1.0"
    version="2.0">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>


    <!--  V A R I A B L E S  -->



    <!--   T E M P L A T E S  -->

    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates select="*"/>
            <!-- excluding processing instructions and comments -->
        </xsl:copy>
    </xsl:template>


    <!-- adaptation of general attribute @creation int  -->

    <xsl:template match="@creation">
        <xsl:attribute name="generatedBy">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>


    <!--  Adaptation of post attributes  -->

    <xsl:template match="t:post/@mode">
        <xsl:attribute name="modality">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>


    <!-- wiki talk: signatureContent in personList to note -->

    <!-- signatureContent>
        <ref type="link">wiki/User_talk:65.94.47.63</ref>
    </signatureContent -->

    <!-- into: -->

    <!--  note type="path-to-userpage">
        <ref type="link">wiki/User_talk:65.94.47.63</ref>
    </note -->

    <xsl:template match="t:signatureContent">
        <note type="path-to-userpage">
            <xsl:apply-templates select="node() | @*"/>
        </note>
    </xsl:template>



    <!-- wiki talk: signed in wiki talk  -->

    <!-- cmc-core: 
    <p> [...] <signed creation="template">—<ref
                target="/wiki/User:RJHall">RJH</ref> (<ref
                    target="/wiki/User_talk:RJHall">talk</ref>) <time>19:56, 23
                        March 2011 (UTC)</time></signed></p -->

    <!-- into CMC-TEI:
    <p> [...] </p><signed generatedBy="template" rend="inline">—<ref
            target="/wiki/User:RJHall">RJH</ref> (<ref
                target="/wiki/User_talk:RJHall">talk</ref>) <time>19:56, 23 March
                    2011 (UTC)</time></signed -->


    <xsl:template match="t:post/t:p[t:signed]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>

        <xsl:apply-templates select="t:signed"/>

    </xsl:template>

    <xsl:template match="t:post/t:p/t:signed">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="rend">
                <xsl:text>inline</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- emojis  -->



    <!-- changing and movin recordingStmt into samplingDecl -->

    <!-- sourceDesc>
        <recordingStmt>
            <recording>
                <equipment>
                    <p><ref target="https://www.whatsapp.com/"
                            >Messenger: WhatsApp chat</ref></p>
                </equipment>
                <respStmt>
                    <resp>Compilation</resp>
                    <orgName>Project <ref
                            target="https://www.whatsapp.com/"
                            >MoCoDa</ref></orgName>
                </respStmt>
                <date>2018-11-04</date>
                <time from="10:03:00" to="12:13:00" />
            </recording>
        </recordingStmt -->


    <!-- encodingDesc>                  
            <samplingDecl>
                <p>
                    <bibl>
                        <ref target="https://www.whatsapp.com/">Messenger: WhatsApp
                                    chat</ref>
                        <respStmt>
                            <resp>Compilation</resp>
                            <orgName>Project <ref target="https://www.whatsapp.com/"
                                    >MoCoDa</ref></orgName>
                        </respStmt>
                        <date>2018-11-04</date>
                        <time from="10:03:00" to="12:13:00"/>
                    </bibl>
                </p>
            </samplingDecl -->


    <xsl:template match="t:recordingStmt"/>

    <xsl:template match="t:sourceDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="*[local-name() != 'recordingStmt']">
                    <xsl:apply-templates select="node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- otherwise there was nothing else than the recordingStmt as in tweets.tei.xml -->
                    <xsl:apply-templates
                        select="ancestor::t:TEI//t:recordingStmt/t:recording/t:equipment/t:p"/> 
                    <xsl:apply-templates
                        select="ancestor::t:TEI//t:recordingStmt/t:recording/t:p"/> 
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="t:encodingDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="samplingDecl" exclude-result-prefixes="#all">
                <xsl:if test="ancestor::t:TEI//t:recordingStmt">
                    <p>
                        <bibl>
                            <xsl:copy-of
                                select="ancestor::t:TEI//t:recordingStmt/t:recording/t:equipment/t:p/t:ref"/>
                            <xsl:copy-of
                                select="ancestor::t:TEI//t:recordingStmt/t:recording/t:respStmt"/>
                            <xsl:copy-of
                                select="ancestor::t:TEI//t:recordingStmt/t:recording/t:date"/>
                            <xsl:copy-of
                                select="ancestor::t:TEI//t:recordingStmt/t:recording/t:time"
                            />
                        </bibl>
                    </p>
                </xsl:if>
                <xsl:copy-of
                    select="ancestor::t:TEI//t:recordingStmt/t:recording/t:p"/>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="t:samplingDecl">
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
