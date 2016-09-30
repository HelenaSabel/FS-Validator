<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>
        <sch:rule context="tei:fDecl">
            <sch:assert test="@optional">The @optional attribute is mandatory to correctly validate
                the feature structure library</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
