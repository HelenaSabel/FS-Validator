<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
   <pattern>
      <rule context="tei:fs[@type eq 'variants.taxonomy']">
         <assert test="tei:f[@name eq 'description']"> The feature “description” is missing
                    </assert>
         <assert test="tei:f[@name eq 'taxonomy']"> The feature “taxonomy” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'description'][parent::fs[@type eq 'variants.taxonomy']]">
         <assert test="tei:string"> The element string is
                        required </assert>
         <report test="tei:string[not(*)]">This feature must contain a string element
                        with content
                    </report>
      </rule>
      <rule context="tei:f[@name eq 'taxonomy'][parent::fs[@type eq 'variants.taxonomy']]">
         <assert test="tei:fs[@type = ('linguistic', 'error', 'material', 'equipolent', 'graphic')]"> Incorrect @type value. Possible values are:
                                'linguistic, error, material, equipolent, graphic'</assert>
      </rule>
      <rule context="tei:fs[@type eq 'linguistic']">
         <assert test="tei:f[@name eq 'category']"> The feature “category” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'category'][parent::fs[@type eq 'linguistic']]">
         <assert test="tei:fs[@type = ('phonetic', 'morphosyntactic', 'lexical', 'language', 'transfer')]"> Incorrect @type value. Possible values are:
                                'phonetic, morphosyntactic, lexical, language-transfer'</assert>
      </rule>
      <rule context="tei:fs[@type eq 'phonetic']">
         <assert test="if (count(./tei:f) gt 2) then tei:f[@name = ('position')] else true()"> The mandatory features are 'process', 'constriction'; and the optional ones are 'position'. There is a feature in this structure that
                    has not been declared </assert>
         <assert test="tei:f[@name eq 'process']"> The feature “process” is missing
                    </assert>
         <assert test="tei:f[@name eq 'constriction']"> The feature “constriction” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'process'][parent::fs[@type eq 'phonetic']]">
         <assert test="tei:symbol[@value = ('addition', 'reduction', 'parallel-evolution')] or tei:fs[@type = ('alteration')]"> Incorrect value. Possible values are: a fs element with one of
                    the following @type attributes 'alteration'
                    or a symbol element with one of the following @value attributes 'addition, reduction, parallel-evolution'</assert>
      </rule>
      <rule context="tei:f[@name eq 'position'][parent::fs[@type eq 'phonetic']]">
         <assert test="tei:symbol[@value = ('start', 'end', 'intern', 'intervocalic', 'interconsonantic')]"> Incorrect @type value. Possible values are:
                                'start, end, intern, intervocalic, interconsonantic'</assert>
      </rule>
      <rule context="tei:f[@name eq 'constriction'][parent::fs[@type eq 'phonetic']]">
         <assert test="tei:binary"> Binary feature.
                        </assert>
      </rule>
      <rule context="tei:fs[@type eq 'alteration']">
         <assert test="tei:f[@name eq 'mode']"> The feature “mode” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'mode'][parent::fs[@type eq 'alteration']]">
         <assert test="tei:symbol[@value = ('dissimilation', 'metathesis', 'lenition', 'fortition', 'analogy', 'sound-loss')] or tei:fs[@type = ('assimilation')]"> Incorrect value. Possible values are: a fs element with one of
                    the following @type attributes 'assimilation'
                    or a symbol element with one of the following @value attributes 'dissimilation, metathesis, lenition, fortition, analogy, sound-loss'</assert>
      </rule>
      <rule context="tei:fs[@type eq 'assimilation']">
         <assert test="if (count(./tei:f) gt 0) then tei:f[@name = ('direction')] else true()"> The mandatory features are ''; and the optional ones are 'direction'. There is a feature in this structure that
                    has not been declared </assert>
      </rule>
      <rule context="tei:f[@name eq 'direction'][parent::fs[@type eq 'assimilation']]"/>
      <rule context="tei:fs[@type eq 'morphosyntatic']">
         <assert test="tei:f[@name eq 'POS']"> The feature “POS” is missing
                    </assert>
         <assert test="tei:f[@name eq 'process']"> The feature “process” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'POS'][parent::fs[@type eq 'morphosyntatic']]">
         <assert test="tei:symbol[@value = ('N', 'DET', 'CONJ', 'PREP', 'ADV')] or tei:fs[@type = ('VB', 'PR')]"> Incorrect value. Possible values are: a fs element with one of
                    the following @type attributes 'VB, PR'
                    or a symbol element with one of the following @value attributes 'N, DET, CONJ, PREP, ADV'</assert>
      </rule>
      <rule context="tei:f[@name eq 'process'][parent::fs[@type eq 'morphosyntatic']]">
         <assert test="tei:symbol[@value = ('stem', 'inflection', 'analogy', 'addition', 'sound-change')] or tei:fs[@type = ('alternation')]"> Incorrect value. Possible values are: a fs element with one of
                    the following @type attributes 'alternation'
                    or a symbol element with one of the following @value attributes 'stem, inflection, analogy, addition, sound-change'</assert>
      </rule>
      <rule context="tei:fs[@type eq 'alternation']">
         <assert test="tei:f[@name eq 'lexeme']"> The feature “lexeme” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'lexeme'][parent::fs[@type eq 'alternation']]">
         <assert test="tei:vAlt/tei:string/text()">This cannot be an empty element</assert>
      </rule>
      <rule context="tei:fs[@type eq 'VB']">
         <assert test="if (count(./tei:f) gt 1) then tei:f[@name = ('agreement')] else true()"> The mandatory features are 'stem-tense'; and the optional ones are 'agreement'. There is a feature in this structure that
                    has not been declared </assert>
         <assert test="tei:f[@name eq 'stem-tense']"> The feature “stem-tense” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'stem-tense'][parent::fs[@type eq 'VB']]">
         <assert test="tei:symbol[@value = ('present', 'past')]"> Incorrect @type value. Possible values are:
                                'present, past'</assert>
      </rule>
      <rule context="tei:f[@name eq 'agreement'][parent::fs[@type eq 'VB']]">
         <assert test="tei:fs[@name ='']"> Required fs of type concord</assert>
      </rule>
      <rule context="tei:fs[@type eq 'concord']">
         <assert test="tei:f[@name eq 'PERS']"> The feature “PERS” is missing
                    </assert>
         <assert test="tei:f[@name eq 'NUM']"> The feature “NUM” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'PERS'][parent::fs[@type eq 'concord']]">
         <assert test="tei:symbol[@value = ('1', '2', '3')]"> Incorrect @type value. Possible values are:
                                '1, 2, 3'</assert>
      </rule>
      <rule context="tei:f[@name eq 'NUM'][parent::fs[@type eq 'concord']]">
         <assert test="tei:symbol[@value = ('sg', 'pl')]"> Incorrect @type value. Possible values are:
                                'sg, pl'</assert>
      </rule>
      <rule context="tei:fs[@type eq 'PR']">
         <assert test="if (count(./tei:f) gt 0) then tei:f[@name = ('agreement', 'case')] else true()"> The mandatory features are ''; and the optional ones are 'agreement', 'case'. There is a feature in this structure that
                    has not been declared </assert>
      </rule>
      <rule context="tei:f[@name eq 'agreement'][parent::fs[@type eq 'PR']]">
         <assert test="tei:fs[@name ='']"> Required fs of type concord</assert>
      </rule>
      <rule context="tei:f[@name eq 'case'][parent::fs[@type eq 'PR']]">
         <assert test="tei:symbol[@value = ('nominative', 'accusative', 'dative', 'genitive')]"> Incorrect @type value. Possible values are:
                                'nominative, accusative, dative, genitive'</assert>
      </rule>
      <rule context="tei:fs[@type eq 'language-transfer']">
         <assert test="tei:f[@name eq 'language']"> The feature “language” is missing
                    </assert>
      </rule>
      <rule context="tei:f[@name eq 'language'][parent::fs[@type eq 'language-transfer']]">
         <assert test="tei:symbol[@value = ('sp', 'it')]"> Incorrect @type value. Possible values are:
                                'sp, it'</assert>
      </rule>
   </pattern>
</schema>
