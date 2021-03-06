<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="xhtml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <meta name="description" content="Black Rock History Website"/>
                <meta name="author" content="Rebecca Parker and Robert Foley"/>
                <title>
                    <xsl:apply-templates select="//teiHeader//titleStmt//title"/>
                </title>
                <xsl:comment>Bootstrap CSS</xsl:comment>
                <link rel="stylesheet"
                    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>

                <xsl:comment>Custom CSS</xsl:comment>
                <link rel="stylesheet" href="css/bootstrap-magnify.css"/>
                <link rel="stylesheet" type="text/css" href="css/style.css"/>
                    <script src="js/jquery.js"></script>
                    <script src="js/bootstrap.min.js"></script>
                    <script src="js/bootstrap-magnify.js"></script>
                    <script>
                        $(document).ready(function() {
                        $('img')
                        .filter(function() {
                        return this.alt.match(/manuscript\simage/);
                        })
                        .magnify();
                        });
                    </script>
               
            </head>
            <body>
                <div id="nav">
                    <h1 class="main">
                        1801 - 1838 Merchant and Shipping Account Log Book
                    </h1>
                    <h2 class="main">Authored by <xsl:apply-templates
                        select="//teiHeader//titleStmt//author"/></h2>
                    <a href="index.html">Home</a> |
                    <a href="about.html">About</a>
                </div>
                <div class="col-xs-12">
                    <!-- RJP:2017-04-30: We have decided to make the TOC appear on a seperate page. Uncomment the code below for it to appear on the same page as the manuscript/transcriptions. -->
                    <!-- <div id="toc" class="col-xs-2">
                    <h3>Table of Contents</h3>
                    <ul>
                        <xsl:apply-templates select="//div[@type = 'page']" mode="toc"/>
                    </ul>
                </div> -->
                    <xsl:apply-templates select="//div[@type = 'page']"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <!-- RJP:2017-04-30: We have decided to make the TOC appear on a seperate page. Uncomment the code below for it to appear on the same page as the manuscript/transcriptions. -->
    <!-- <xsl:template match="div[@type = 'page']" mode="toc">
        <li>
            <a href="#page{count(preceding::div[@type='page']) + 1}">Page <xsl:apply-templates
                    select="count(preceding::div[@type = 'page']) + 1"/></a>
        </li>
    </xsl:template> -->
    <xsl:template match="div[@type = 'page']">
        <div id="page{count(preceding::div[@type = 'page']) + 1}" class="col-xs-12 page">

            <div class="manu_Image col-md-4">
                <a href="images/{@facs}" target="_blank">
                    <img alt="manuscript image for page {count(preceding::div[@type='page']) + 1}"
                        src="images/{@facs}"/>
                </a>

            </div>
            <div class="col-md-2"/>
            <div class="manu_Content col-md-6">
                <hr class="pageDivider"/>
                <span class="pageNum">
                    <xsl:text>Page </xsl:text>
                    <xsl:apply-templates select="count(preceding::div[@type = 'page']) + 1"/>
                </span>
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="date[not(parent::title)]">
        <span class="date" title="{@when}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="div[@type = 'group']">
        <div class="section">
            <hr class="sectionDivider"/>
            <xsl:if test="child::head">
                <span class="sectionHead">
                    <xsl:apply-templates select="child::head"/>
                </span>
            </xsl:if>
            <xsl:apply-templates select="child::list"/>
        </div>
    </xsl:template>
    <xsl:template match="list">
        <xsl:if test="child::head">
            <span class="entryHead">
                <xsl:apply-templates select="child::head"/>
            </span>
        </xsl:if>
        <ul class="entries">
            <xsl:apply-templates select="child::item"/>
        </ul>
    </xsl:template>
    <xsl:template match="item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="measure[@commodity]">
        <span class="com" title="{@quantity} {@unit} {@commodity}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="measure[@type = 'currency'][matches(@ana, '\d{2,}_\d{2,}_\d{2,}')]">
        <!--
            RJP:2017-05-21: Currently not function isn't working to only grab the currency elements that are not followed by the hyphen notation
            
            <xsl:if test="not(preceding-sibling::g[@ref='#longHyphen'])">
            <span class="currSpacer" title="The *** does not appear in the original document and is only included in the transcription for purposes of webpage layout."><xsl:text> *** </xsl:text></span>
        </xsl:if>-->
        <span class="curr"
            title="£{tokenize(@ana,'_')[1]} s{tokenize(@ana,'_')[2]} d{tokenize(@ana,'_')[3]}">
            <!-- RJP:2017-03-16: The regular expression to match on two digits at time is not working here. Consult M.Kay and conisder creating variable that gets regular expression and can be entered here in place. Otherwise will need to change XML to better suit info supplied in attribute.  -->
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="persName">
        <span class="person">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- RJP:2017-03-16: Matches for Odd Spelling and Missing Text! -->
    <xsl:template match="choice">
        <span class="spelling" title="Spelling retained from original manuscript: {child::sic}">
            <xsl:apply-templates select="child::reg"/>
        </span>
    </xsl:template>
    <xsl:template match="unclear">
        <xsl:choose>
            <xsl:when test="child::supplied">
                <span class="unclear"
                    title="The text provided here was interpreted by a project editor (ID: {child::supplied/tokenize(@resp,'#')[last()]}) because the transcription source was unclear.">
                    <!-- RJP:2017-03-14: In the future, change this so the @resp goes up into the teiHeader and matches on the full name of the editor associated with the current() ID. -->
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="unclear"
                    title="The text is unclear and could not be transcribed. Reason: {@reason}.">
                    <xsl:text> [MISSING TEXT] </xsl:text>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- RJP:2017-03-14:Matches for Special Characters! -->
    <xsl:template match="add[preceding-sibling::g[@ref = '#ditto']]">
        <span class="ditto"
            title="The text provided here was interpreted by a project editor (ID: {tokenize(@resp,'#')[last()]}). In the manuscript this text is represented by Bartram's ditto character.">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="g[@ref = '#longHyphen']">
        <span class="hyphen"
            title="The actual number of hyphens present here in the manuscript is {@n}; however, we have standardized the number of hyphens appearing here for the sake of web formatting.">
            <xsl:text>- - -</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="g[@ref = '#currency']">
        <span class="currency"
            title="A symbol bearing resemblance to the currency £ appears before money notation.">
            <xsl:text>£</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="g[@ref = '#afterName']">
        <span class="afterName"
            title="A symbol appears here after this proper name that we speculate indicates a signature.">
            <xsl:text> * </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="g[@ref = '#stItem']">
        <span class="stItem"
            title="A symbol appears here before the start of most logged items. It bears resemblance to the word To, and seems to be the way Bartram noted new entries.">
            <xsl:text>To</xsl:text>
        </span>
    </xsl:template>
</xsl:stylesheet>
