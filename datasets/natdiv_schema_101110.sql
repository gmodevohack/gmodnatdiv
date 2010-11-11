-- ######################################################
-- module general
-- ######################################################

create table tableinfo (
    tableinfo_id serial not null,
    primary key (tableinfo_id),
    name varchar(30) not null,
    primary_key_column varchar(30) null,
    is_view int not null default 0,
    view_on_table_id int null,
    superclass_table_id int null,
    is_updateable int not null default 1,
    modification_date date not null default now(),
    constraint tableinfo_c1 unique (name)
);

COMMENT ON TABLE tableinfo IS NULL;


create table db (
    db_id serial not null,
    primary key (db_id),
    name varchar(255) not null,
    description varchar(255) null,
    urlprefix varchar(255) null,
    url varchar(255) null,
    constraint db_c1 unique (name)
);

COMMENT ON TABLE db IS 'A database authority. Typical databases in
bioinformatics are FlyBase, GO, UniProt, NCBI, MGI, etc. The authority
is generally known by this shortened form, which is unique within the
bioinformatics and biomedical realm.  To Do - add support for URIs,
URNs (e.g. LSIDs). We can do this by treating the URL as a URI -
however, some applications may expect this to be resolvable - to be
decided.';


create table dbxref (
    dbxref_id serial not null,
    primary key (dbxref_id),
    db_id int not null,
    foreign key (db_id) references db (db_id) on delete cascade INITIALLY DEFERRED,
    accession varchar(255) not null,
    version varchar(255) not null default '',
    description text,
    constraint dbxref_c1 unique (db_id,accession,version)
);
create index dbxref_idx1 on dbxref (db_id);
create index dbxref_idx2 on dbxref (accession);
create index dbxref_idx3 on dbxref (version);

COMMENT ON TABLE dbxref IS 'A unique, global, public, stable identifier. Not necessarily an external reference - can reference data items inside the particular chado instance being used. Typically a row in a table can be uniquely identified with a primary identifier (called dbxref_id); a table may also have secondary identifiers (in a linking table <T>_dbxref). A dbxref is generally written as <DB>:<ACCESSION> or as <DB>:<ACCESSION>:<VERSION>.';

COMMENT ON COLUMN dbxref.accession IS 'The local part of the identifier. Guaranteed by the db authority to be unique for that db.';

-- ######################################################
-- module cv
-- ######################################################

create table cv (
    cv_id serial not null,
    primary key (cv_id),
    name varchar(255) not null,
   definition text,
   constraint cv_c1 unique (name)
);

COMMENT ON TABLE cv IS 'A controlled vocabulary or ontology. A cv is
composed of cvterms (AKA terms, classes, types, universals - relations
and properties are also stored in cvterm) and the relationships
between them.';

COMMENT ON COLUMN cv.name IS 'The name of the ontology. This
corresponds to the obo-format -namespace-. cv names uniquely identify
the cv. In OBO file format, the cv.name is known as the namespace.';

COMMENT ON COLUMN cv.definition IS 'A text description of the criteria for
membership of this ontology.';

create table cvterm (
    cvterm_id serial not null,
    primary key (cvterm_id),
    cv_id int not null,
    foreign key (cv_id) references cv (cv_id) on delete cascade INITIALLY DEFERRED,
    name varchar(1024) not null,
    definition text,
    dbxref_id int not null,
    foreign key (dbxref_id) references dbxref (dbxref_id) on delete set null INITIALLY DEFERRED,
    is_obsolete int not null default 0,
    is_relationshiptype int not null default 0,
    constraint cvterm_c1 unique (name,cv_id,is_obsolete),
    constraint cvterm_c2 unique (dbxref_id)
);
create index cvterm_idx1 on cvterm (cv_id);
create index cvterm_idx2 on cvterm (name);
create index cvterm_idx3 on cvterm (dbxref_id);

COMMENT ON TABLE cvterm IS 'A term, class, universal or type within an
ontology or controlled vocabulary.  This table is also used for
relations and properties. cvterms constitute nodes in the graph
defined by the collection of cvterms and cvterm_relationships.';

COMMENT ON COLUMN cvterm.cv_id IS 'The cv or ontology or namespace to which
this cvterm belongs.';

COMMENT ON COLUMN cvterm.name IS 'A concise human-readable name or
label for the cvterm. Uniquely identifies a cvterm within a cv.';

COMMENT ON COLUMN cvterm.definition IS 'A human-readable text
definition.';

COMMENT ON COLUMN cvterm.dbxref_id IS 'Primary identifier dbxref - The
unique global OBO identifier for this cvterm.  Note that a cvterm may
have multiple secondary dbxrefs - see also table: cvterm_dbxref.';

COMMENT ON COLUMN cvterm.is_obsolete IS 'Boolean 0=false,1=true; see
GO documentation for details of obsoletion. Note that two terms with
different primary dbxrefs may exist if one is obsolete.';

COMMENT ON COLUMN cvterm.is_relationshiptype IS 'Boolean
0=false,1=true relations or relationship types (also known as Typedefs
in OBO format, or as properties or slots) form a cv/ontology in
themselves. We use this flag to indicate whether this cvterm is an
actual term/class/universal or a relation. Relations may be drawn from
the OBO Relations ontology, but are not exclusively drawn from there.';

COMMENT ON INDEX cvterm_c1 IS 'A name can mean different things in
different contexts; for example "chromosome" in SO and GO. A name
should be unique within an ontology or cv. A name may exist twice in a
cv, in both obsolete and non-obsolete forms - these will be for
different cvterms with different OBO identifiers; so GO documentation
for more details on obsoletion. Note that occasionally multiple
obsolete terms with the same name will exist in the same cv. If this
is a possibility for the ontology under consideration (e.g. GO) then the
ID should be appended to the name to ensure uniqueness.';

COMMENT ON INDEX cvterm_c2 IS 'The OBO identifier is globally unique.';

create table cvterm_relationship (
    cvterm_relationship_id serial not null,
    primary key (cvterm_relationship_id),
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    subject_id int not null,
    foreign key (subject_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    object_id int not null,
    foreign key (object_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    constraint cvterm_relationship_c1 unique (subject_id,object_id,type_id)
);
create index cvterm_relationship_idx1 on cvterm_relationship (type_id);
create index cvterm_relationship_idx2 on cvterm_relationship (subject_id);
create index cvterm_relationship_idx3 on cvterm_relationship (object_id);

COMMENT ON TABLE cvterm_relationship IS 'A relationship linking two
cvterms. Each cvterm_relationship constitutes an edge in the graph
defined by the collection of cvterms and cvterm_relationships. The
meaning of the cvterm_relationship depends on the definition of the
cvterm R refered to by type_id. However, in general the definitions
are such that the statement "all SUBJs REL some OBJ" is true. The
cvterm_relationship statement is about the subject, not the
object. For example "insect wing part_of thorax".';

COMMENT ON COLUMN cvterm_relationship.subject_id IS 'The subject of
the subj-predicate-obj sentence. The cvterm_relationship is about the
subject. In a graph, this typically corresponds to the child node.';

COMMENT ON COLUMN cvterm_relationship.object_id IS 'The object of the
subj-predicate-obj sentence. The cvterm_relationship refers to the
object. In a graph, this typically corresponds to the parent node.';

COMMENT ON COLUMN cvterm_relationship.type_id IS 'The nature of the
relationship between subject and object. Note that relations are also
housed in the cvterm table, typically from the OBO relationship
ontology, although other relationship types are allowed.';

create table cvtermpath (
    cvtermpath_id serial not null,
    primary key (cvtermpath_id),
    type_id int,
    foreign key (type_id) references cvterm (cvterm_id) on delete set null INITIALLY DEFERRED,
    subject_id int not null,
    foreign key (subject_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    object_id int not null,
    foreign key (object_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    cv_id int not null,
    foreign key (cv_id) references cv (cv_id) on delete cascade INITIALLY DEFERRED,
    pathdistance int,
    constraint cvtermpath_c1 unique (subject_id,object_id,type_id,pathdistance)
);
create index cvtermpath_idx1 on cvtermpath (type_id);
create index cvtermpath_idx2 on cvtermpath (subject_id);
create index cvtermpath_idx3 on cvtermpath (object_id);
create index cvtermpath_idx4 on cvtermpath (cv_id);

COMMENT ON TABLE cvtermpath IS 'The reflexive transitive closure of
the cvterm_relationship relation.';

COMMENT ON COLUMN cvtermpath.type_id IS 'The relationship type that
this is a closure over. If null, then this is a closure over ALL
relationship types. If non-null, then this references a relationship
cvterm - note that the closure will apply to both this relationship
AND the OBO_REL:is_a (subclass) relationship.';

COMMENT ON COLUMN cvtermpath.cv_id IS 'Closures will mostly be within
one cv. If the closure of a relationship traverses a cv, then this
refers to the cv of the object_id cvterm.';

COMMENT ON COLUMN cvtermpath.pathdistance IS 'The number of steps
required to get from the subject cvterm to the object cvterm, counting
from zero (reflexive relationship).';

create table cvtermsynonym (
    cvtermsynonym_id serial not null,
    primary key (cvtermsynonym_id),
    cvterm_id int not null,
    foreign key (cvterm_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    synonym varchar(1024) not null,
    type_id int,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade  INITIALLY DEFERRED,
    constraint cvtermsynonym_c1 unique (cvterm_id,synonym)
);
create index cvtermsynonym_idx1 on cvtermsynonym (cvterm_id);

COMMENT ON TABLE cvtermsynonym IS 'A cvterm actually represents a
distinct class or concept. A concept can be refered to by different
phrases or names. In addition to the primary name (cvterm.name) there
can be a number of alternative aliases or synonyms. For example, "T
cell" as a synonym for "T lymphocyte".';

COMMENT ON COLUMN cvtermsynonym.type_id IS 'A synonym can be exact,
narrower, or broader than.';


create table cvterm_dbxref (
    cvterm_dbxref_id serial not null,
    primary key (cvterm_dbxref_id),
    cvterm_id int not null,
    foreign key (cvterm_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    dbxref_id int not null,
    foreign key (dbxref_id) references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED,
    is_for_definition int not null default 0,
    constraint cvterm_dbxref_c1 unique (cvterm_id,dbxref_id)
);
create index cvterm_dbxref_idx1 on cvterm_dbxref (cvterm_id);
create index cvterm_dbxref_idx2 on cvterm_dbxref (dbxref_id);

COMMENT ON TABLE cvterm_dbxref IS 'In addition to the primary
identifier (cvterm.dbxref_id) a cvterm can have zero or more secondary
identifiers/dbxrefs, which may refer to records in external
databases. The exact semantics of cvterm_dbxref are not fixed. For
example: the dbxref could be a pubmed ID that is pertinent to the
cvterm, or it could be an equivalent or similar term in another
ontology. For example, GO cvterms are typically linked to InterPro
IDs, even though the nature of the relationship between them is
largely one of statistical association. The dbxref may be have data
records attached in the same database instance, or it could be a
"hanging" dbxref pointing to some external database. NOTE: If the
desired objective is to link two cvterms together, and the nature of
the relation is known and holds for all instances of the subject
cvterm then consider instead using cvterm_relationship together with a
well-defined relation.';

COMMENT ON COLUMN cvterm_dbxref.is_for_definition IS 'A
cvterm.definition should be supported by one or more references. If
this column is true, the dbxref is not for a term in an external database -
it is a dbxref for provenance information for the definition.';


create table cvtermprop ( 
    cvtermprop_id serial not null, 
    primary key (cvtermprop_id), 
    cvterm_id int not null, 
    foreign key (cvterm_id) references cvterm (cvterm_id) on delete cascade, 
    type_id int not null, 
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade, 
    value text not null default '', 
    rank int not null default 0,

    unique(cvterm_id, type_id, value, rank) 
);
create index cvtermprop_idx1 on cvtermprop (cvterm_id);
create index cvtermprop_idx2 on cvtermprop (type_id);

COMMENT ON TABLE cvtermprop IS 'Additional extensible properties can be attached to a cvterm using this table. Corresponds to -AnnotationProperty- in W3C OWL format.';

COMMENT ON COLUMN cvtermprop.type_id IS 'The name of the property or slot is a cvterm. The meaning of the property is defined in that cvterm.';

COMMENT ON COLUMN cvtermprop.value IS 'The value of the property, represented as text. Numeric values are converted to their text representation.';

COMMENT ON COLUMN cvtermprop.rank IS 'Property-Value ordering. Any
cvterm can have multiple values for any particular property type -
these are ordered in a list using rank, counting from zero. For
properties that are single-valued rather than multi-valued, the
default 0 value should be used.';


create table dbxrefprop (
    dbxrefprop_id serial not null,
    primary key (dbxrefprop_id),
    dbxref_id int not null,
    foreign key (dbxref_id) references dbxref (dbxref_id) INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) INITIALLY DEFERRED,
    value text not null default '',
    rank int not null default 0,
    constraint dbxrefprop_c1 unique (dbxref_id,type_id,rank)
);
create index dbxrefprop_idx1 on dbxrefprop (dbxref_id);
create index dbxrefprop_idx2 on dbxrefprop (type_id);

COMMENT ON TABLE dbxrefprop IS 'Metadata about a dbxref. Note that this is not defined in the dbxref module, as it depends on the cvterm table. This table has a structure analagous to cvtermprop.';


-- ######################################################
-- module pub
-- ######################################################


create table pub (
    pub_id serial not null,
    primary key (pub_id),
    title text,
    volumetitle text,
    volume varchar(255),
    series_name varchar(255),
    issue varchar(255),
    pyear varchar(255),
    pages varchar(255),
    miniref varchar(255),
    uniquename text not null,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    is_obsolete boolean default 'false',
    publisher varchar(255),
    pubplace varchar(255),
    constraint pub_c1 unique (uniquename)
);
CREATE INDEX pub_idx1 ON pub (type_id);

COMMENT ON TABLE pub IS 'A documented provenance artefact - publications,
documents, personal communication.';
COMMENT ON COLUMN pub.title IS 'Descriptive general heading.';
COMMENT ON COLUMN pub.volumetitle IS 'Title of part if one of a series.';
COMMENT ON COLUMN pub.series_name IS 'Full name of (journal) series.';
COMMENT ON COLUMN pub.pages IS 'Page number range[s], e.g. 457--459, viii + 664pp, lv--lvii.';
COMMENT ON COLUMN pub.type_id IS  'The type of the publication (book, journal, poem, graffiti, etc). Uses pub cv.';


create table pub_relationship (
    pub_relationship_id serial not null,
    primary key (pub_relationship_id),
    subject_id int not null,
    foreign key (subject_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    object_id int not null,
    foreign key (object_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,

    constraint pub_relationship_c1 unique (subject_id,object_id,type_id)
);
create index pub_relationship_idx1 on pub_relationship (subject_id);
create index pub_relationship_idx2 on pub_relationship (object_id);
create index pub_relationship_idx3 on pub_relationship (type_id);

COMMENT ON TABLE pub_relationship IS 'Handle relationships between
publications, e.g. when one publication makes others obsolete, when one
publication contains errata with respect to other publication(s), or
when one publication also appears in another pub.';


create table pub_dbxref (
    pub_dbxref_id serial not null,
    primary key (pub_dbxref_id),
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    dbxref_id int not null,
    foreign key (dbxref_id) references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED,
    is_current boolean not null default 'true',
    constraint pub_dbxref_c1 unique (pub_id,dbxref_id)
);
create index pub_dbxref_idx1 on pub_dbxref (pub_id);
create index pub_dbxref_idx2 on pub_dbxref (dbxref_id);

COMMENT ON TABLE pub_dbxref IS 'Handle links to repositories,
e.g. Pubmed, Biosis, zoorec, OCLC, Medline, ISSN, coden...';



create table pubauthor (
    pubauthor_id serial not null,
    primary key (pubauthor_id),
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    rank int not null,
    editor boolean default 'false',
    surname varchar(100) not null,
    givennames varchar(100),
    suffix varchar(100),

    constraint pubauthor_c1 unique (pub_id, rank)
);
create index pubauthor_idx2 on pubauthor (pub_id);

COMMENT ON TABLE pubauthor IS 'An author for a publication. Note the denormalisation (hence lack of _ in table name) - this is deliberate as it is in general too hard to assign IDs to authors.';
COMMENT ON COLUMN pubauthor.givennames IS 'First name, initials';
COMMENT ON COLUMN pubauthor.suffix IS 'Jr., Sr., etc';
COMMENT ON COLUMN pubauthor.rank IS 'Order of author in author list for this pub - order is important.';
COMMENT ON COLUMN pubauthor.editor IS 'Indicates whether the author is an editor for linked publication. Note: this is a boolean field but does not follow the normal chado convention for naming booleans.';



create table pubprop (
    pubprop_id serial not null,
    primary key (pubprop_id),
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value text not null,
    rank integer,

    constraint pubprop_c1 unique (pub_id,type_id,rank)
);
create index pubprop_idx1 on pubprop (pub_id);
create index pubprop_idx2 on pubprop (type_id);

COMMENT ON TABLE pubprop IS 'Property-value pairs for a pub. Follows standard chado pattern.';
-- ######################################################
-- module organism
-- ######################################################


create table organism (
	organism_id serial not null,
	primary key (organism_id),
	abbreviation varchar(255) null,
	genus varchar(255) not null,
	species varchar(255) not null,
	common_name varchar(255) null,
	comment text null,
	constraint organism_c1 unique (genus,species)
);

COMMENT ON TABLE organism IS 'The organismal taxonomic
classification. Note that phylogenies are represented using the
phylogeny module, and taxonomies can be represented using the cvterm
module or the phylogeny module.';

COMMENT ON COLUMN organism.species IS 'A type of organism is always
uniquely identified by genus and species. When mapping from the NCBI
taxonomy names.dmp file, this column must be used where it
is present, as the common_name column is not always unique (e.g. environmental
samples). If a particular strain or subspecies is to be represented,
this is appended onto the species name. Follows standard NCBI taxonomy
pattern.';


create table organism_dbxref (
    organism_dbxref_id serial not null,
    primary key (organism_dbxref_id),
    organism_id int not null,
    foreign key (organism_id) references organism (organism_id) on delete cascade INITIALLY DEFERRED,
    dbxref_id int not null,
    foreign key (dbxref_id) references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED,
    constraint organism_dbxref_c1 unique (organism_id,dbxref_id)
);
create index organism_dbxref_idx1 on organism_dbxref (organism_id);
create index organism_dbxref_idx2 on organism_dbxref (dbxref_id);


create table organismprop (
    organismprop_id serial not null,
    primary key (organismprop_id),
    organism_id int not null,
    foreign key (organism_id) references organism (organism_id) on delete cascade INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value text null,
    rank int not null default 0,
    constraint organismprop_c1 unique (organism_id,type_id,rank)
);
create index organismprop_idx1 on organismprop (organism_id);
create index organismprop_idx2 on organismprop (type_id);

COMMENT ON TABLE organismprop IS 'Tag-value properties - follows standard chado model.';

-- ######################################################
-- module sequence
-- ######################################################


create table feature (
    feature_id serial not null,
    primary key (feature_id),
    dbxref_id int,
    foreign key (dbxref_id) references dbxref (dbxref_id) on delete set null INITIALLY DEFERRED,
    organism_id int not null,
    foreign key (organism_id) references organism (organism_id) on delete cascade INITIALLY DEFERRED,
    name varchar(255),
    uniquename text not null,
    residues text,
    seqlen int,
    md5checksum char(32),
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    is_analysis boolean not null default 'false',
    is_obsolete boolean not null default 'false',
    timeaccessioned timestamp not null default current_timestamp,
    timelastmodified timestamp not null default current_timestamp,
    constraint feature_c1 unique (organism_id,uniquename,type_id)
);
create sequence feature_uniquename_seq;
create index feature_name_ind1 on feature(name);
create index feature_idx1 on feature (dbxref_id);
create index feature_idx2 on feature (organism_id);
create index feature_idx3 on feature (type_id);
create index feature_idx4 on feature (uniquename);
create index feature_idx5 on feature (lower(name));

ALTER TABLE feature ALTER residues SET STORAGE EXTERNAL;

COMMENT ON TABLE feature IS 'A feature is a biological sequence or a
section of a biological sequence, or a collection of such
sections. Examples include genes, exons, transcripts, regulatory
regions, polypeptides, protein domains, chromosome sequences, sequence
variations, cross-genome match regions such as hits and HSPs and so
on; see the Sequence Ontology for more. The combination of
organism_id, uniquename and type_id should be unique.';

COMMENT ON COLUMN feature.dbxref_id IS 'An optional primary public stable
identifier for this feature. Secondary identifiers and external
dbxrefs go in the table feature_dbxref.';

COMMENT ON COLUMN feature.organism_id IS 'The organism to which this feature
belongs. This column is mandatory.';

COMMENT ON COLUMN feature.name IS 'The optional human-readable common name for
a feature, for display purposes.';

COMMENT ON COLUMN feature.uniquename IS 'The unique name for a feature; may
not be necessarily be particularly human-readable, although this is
preferred. This name must be unique for this type of feature within
this organism.';

COMMENT ON COLUMN feature.residues IS 'A sequence of alphabetic characters
representing biological residues (nucleic acids, amino acids). This
column does not need to be manifested for all features; it is optional
for features such as exons where the residues can be derived from the
featureloc. It is recommended that the value for this column be
manifested for features which may may non-contiguous sublocations (e.g.
transcripts), since derivation at query time is non-trivial. For
expressed sequence, the DNA sequence should be used rather than the
RNA sequence. The default storage method for the residues column is
EXTERNAL, which will store it uncompressed to make substring operations
faster.';

COMMENT ON COLUMN feature.seqlen IS 'The length of the residue feature. See
column:residues. This column is partially redundant with the residues
column, and also with featureloc. This column is required because the
location may be unknown and the residue sequence may not be
manifested, yet it may be desirable to store and query the length of
the feature. The seqlen should always be manifested where the length
of the sequence is known.';

COMMENT ON COLUMN feature.md5checksum IS 'The 32-character checksum of the sequence,
calculated using the MD5 algorithm. This is practically guaranteed to
be unique for any feature. This column thus acts as a unique
identifier on the mathematical sequence.';

COMMENT ON COLUMN feature.type_id IS 'A required reference to a table:cvterm
giving the feature type. This will typically be a Sequence Ontology
identifier. This column is thus used to subclass the feature table.';

COMMENT ON COLUMN feature.is_analysis IS 'Boolean indicating whether this
feature is annotated or the result of an automated analysis. Analysis
results also use the companalysis module. Note that the dividing line
between analysis and annotation may be fuzzy, this should be determined on
a per-project basis in a consistent manner. One requirement is that
there should only be one non-analysis version of each wild-type gene
feature in a genome, whereas the same gene feature can be predicted
multiple times in different analyses.';

COMMENT ON COLUMN feature.is_obsolete IS 'Boolean indicating whether this
feature has been obsoleted. Some chado instances may choose to simply
remove the feature altogether, others may choose to keep an obsolete
row in the table.';

COMMENT ON COLUMN feature.timeaccessioned IS 'For handling object
accession or modification timestamps (as opposed to database auditing data,
handled elsewhere). The expectation is that these fields would be
available to software interacting with chado.';

COMMENT ON COLUMN feature.timelastmodified IS 'For handling object
accession or modification timestamps (as opposed to database auditing data,
handled elsewhere). The expectation is that these fields would be
available to software interacting with chado.';



create table featureloc (
    featureloc_id serial not null,
    primary key (featureloc_id),
    feature_id int not null,
    foreign key (feature_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    srcfeature_id int,
    foreign key (srcfeature_id) references feature (feature_id) on delete set null INITIALLY DEFERRED,
    fmin int,
    is_fmin_partial boolean not null default 'false',
    fmax int,
    is_fmax_partial boolean not null default 'false',
    strand smallint,
    phase int,
    residue_info text,
    locgroup int not null default 0,
    rank int not null default 0,
    constraint featureloc_c1 unique (feature_id,locgroup,rank),
    constraint featureloc_c2 check (fmin <= fmax)
);
create index featureloc_idx1 on featureloc (feature_id);
create index featureloc_idx2 on featureloc (srcfeature_id);
create index featureloc_idx3 on featureloc (srcfeature_id,fmin,fmax);

COMMENT ON TABLE featureloc IS 'The location of a feature relative to
another feature. Important: interbase coordinates are used. This is
vital as it allows us to represent zero-length features e.g. splice
sites, insertion points without an awkward fuzzy system. Features
typically have exactly ONE location, but this need not be the
case. Some features may not be localized (e.g. a gene that has been
characterized genetically but no sequence or molecular information is
available). Note on multiple locations: Each feature can have 0 or
more locations. Multiple locations do NOT indicate non-contiguous
locations (if a feature such as a transcript has a non-contiguous
location, then the subfeatures such as exons should always be
manifested). Instead, multiple featurelocs for a feature designate
alternate locations or grouped locations; for instance, a feature
designating a blast hit or hsp will have two locations, one on the
query feature, one on the subject feature. Features representing
sequence variation could have alternate locations instantiated on a
feature on the mutant strain. The column:rank is used to
differentiate these different locations. Reflexive locations should
never be stored - this is for -proper- (i.e. non-self) locations only; nothing should be located relative to itself.';

COMMENT ON COLUMN featureloc.feature_id IS 'The feature that is being located. Any feature can have zero or more featurelocs.';

COMMENT ON COLUMN featureloc.srcfeature_id IS 'The source feature which this location is relative to. Every location is relative to another feature (however, this column is nullable, because the srcfeature may not be known). All locations are -proper- that is, nothing should be located relative to itself. No cycles are allowed in the featureloc graph.';

COMMENT ON COLUMN featureloc.fmin IS 'The leftmost/minimal boundary in the linear range represented by the featureloc. Sometimes (e.g. in Bioperl) this is called -start- although this is confusing because it does not necessarily represent the 5-prime coordinate. Important: This is space-based (interbase) coordinates, counting from zero. To convert this to the leftmost position in a base-oriented system (eg GFF, Bioperl), add 1 to fmin.';

COMMENT ON COLUMN featureloc.fmax IS 'The rightmost/maximal boundary in the linear range represented by the featureloc. Sometimes (e.g. in bioperl) this is called -end- although this is confusing because it does not necessarily represent the 3-prime coordinate. Important: This is space-based (interbase) coordinates, counting from zero. No conversion is required to go from fmax to the rightmost coordinate in a base-oriented system that counts from 1 (e.g. GFF, Bioperl).';

COMMENT ON COLUMN featureloc.strand IS 'The orientation/directionality of the
location. Should be 0, -1 or +1.';

COMMENT ON COLUMN featureloc.rank IS 'Used when a feature has >1
location, otherwise the default rank 0 is used. Some features (e.g.
blast hits and HSPs) have two locations - one on the query and one on
the subject. Rank is used to differentiate these. Rank=0 is always
used for the query, Rank=1 for the subject. For multiple alignments,
assignment of rank is arbitrary. Rank is also used for
sequence_variant features, such as SNPs. Rank=0 indicates the wildtype
(or baseline) feature, Rank=1 indicates the mutant (or compared) feature.';

COMMENT ON COLUMN featureloc.locgroup IS 'This is used to manifest redundant,
derivable extra locations for a feature. The default locgroup=0 is
used for the DIRECT location of a feature. Important: most Chado users may
never use featurelocs WITH logroup > 0. Transitively derived locations
are indicated with locgroup > 0. For example, the position of an exon on
a BAC and in global chromosome coordinates. This column is used to
differentiate these groupings of locations. The default locgroup 0
is used for the main or primary location, from which the others can be
derived via coordinate transformations. Another example of redundant
locations is storing ORF coordinates relative to both transcript and
genome. Redundant locations open the possibility of the database
getting into inconsistent states; this schema gives us the flexibility
of both warehouse instantiations with redundant locations (easier for
querying) and management instantiations with no redundant
locations. An example of using both locgroup and rank: imagine a
feature indicating a conserved region between the chromosomes of two
different species. We may want to keep redundant locations on both
contigs and chromosomes. We would thus have 4 locations for the single
conserved region feature - two distinct locgroups (contig level and
chromosome level) and two distinct ranks (for the two species).';

COMMENT ON COLUMN featureloc.residue_info IS 'Alternative residues,
when these differ from feature.residues. For instance, a SNP feature
located on a wild and mutant protein would have different alternative residues.
for alignment/similarity features, the alternative residues is used to
represent the alignment string (CIGAR format). Note on variation
features; even if we do not want to instantiate a mutant
chromosome/contig feature, we can still represent a SNP etc with 2
locations, one (rank 0) on the genome, the other (rank 1) would have
most fields null, except for alternative residues.';

COMMENT ON COLUMN featureloc.phase IS 'Phase of translation with
respect to srcfeature_id.
Values are 0, 1, 2. It may not be possible to manifest this column for
some features such as exons, because the phase is dependant on the
spliceform (the same exon can appear in multiple spliceforms). This column is mostly useful for predicted exons and CDSs.';

COMMENT ON COLUMN featureloc.is_fmin_partial IS 'This is typically
false, but may be true if the value for column:fmin is inaccurate or
the leftmost part of the range is unknown/unbounded.';

COMMENT ON COLUMN featureloc.is_fmax_partial IS 'This is typically
false, but may be true if the value for column:fmax is inaccurate or
the rightmost part of the range is unknown/unbounded.';




create table featureloc_pub (
    featureloc_pub_id serial not null,
    primary key (featureloc_pub_id),
    featureloc_id int not null,
    foreign key (featureloc_id) references featureloc (featureloc_id) on delete cascade INITIALLY DEFERRED,
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    constraint featureloc_pub_c1 unique (featureloc_id,pub_id)
);
create index featureloc_pub_idx1 on featureloc_pub (featureloc_id);
create index featureloc_pub_idx2 on featureloc_pub (pub_id);

COMMENT ON TABLE featureloc_pub IS 'Provenance of featureloc. Linking table between featurelocs and publications that mention them.';



create table feature_pub (
    feature_pub_id serial not null,
    primary key (feature_pub_id),
    feature_id int not null,
    foreign key (feature_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    constraint feature_pub_c1 unique (feature_id,pub_id)
);
create index feature_pub_idx1 on feature_pub (feature_id);
create index feature_pub_idx2 on feature_pub (pub_id);

COMMENT ON TABLE feature_pub IS 'Provenance. Linking table between features and publications that mention them.';



create table feature_pubprop (
    feature_pubprop_id serial not null,
    primary key (feature_pubprop_id),
    feature_pub_id int not null,
    foreign key (feature_pub_id) references feature_pub (feature_pub_id) on delete cascade INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value text null,
    rank int not null default 0,
    constraint feature_pubprop_c1 unique (feature_pub_id,type_id,rank)
);
create index feature_pubprop_idx1 on feature_pubprop (feature_pub_id);

COMMENT ON TABLE feature_pubprop IS 'Property or attribute of a feature_pub link.';



create table featureprop (
    featureprop_id serial not null,
    primary key (featureprop_id),
    feature_id int not null,
    foreign key (feature_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value text null,
    rank int not null default 0,
    constraint featureprop_c1 unique (feature_id,type_id,rank)
);
create index featureprop_idx1 on featureprop (feature_id);
create index featureprop_idx2 on featureprop (type_id);

COMMENT ON TABLE featureprop IS 'A feature can have any number of slot-value property tags attached to it. This is an alternative to hardcoding a list of columns in the relational schema, and is completely extensible.';

COMMENT ON COLUMN featureprop.type_id IS 'The name of the
property/slot is a cvterm. The meaning of the property is defined in
that cvterm. Certain property types will only apply to certain feature
types (e.g. the anticodon property will only apply to tRNA features) ;
the types here come from the sequence feature property ontology.';

COMMENT ON COLUMN featureprop.value IS 'The value of the property, represented as text. Numeric values are converted to their text representation. This is less efficient than using native database types, but is easier to query.';

COMMENT ON COLUMN featureprop.rank IS 'Property-Value ordering. Any
feature can have multiple values for any particular property type -
these are ordered in a list using rank, counting from zero. For
properties that are single-valued rather than multi-valued, the
default 0 value should be used';

COMMENT ON INDEX featureprop_c1 IS 'For any one feature, multivalued
property-value pairs must be differentiated by rank.';



create table featureprop_pub (
    featureprop_pub_id serial not null,
    primary key (featureprop_pub_id),
    featureprop_id int not null,
    foreign key (featureprop_id) references featureprop (featureprop_id) on delete cascade INITIALLY DEFERRED,
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    constraint featureprop_pub_c1 unique (featureprop_id,pub_id)
);
create index featureprop_pub_idx1 on featureprop_pub (featureprop_id);
create index featureprop_pub_idx2 on featureprop_pub (pub_id);

COMMENT ON TABLE featureprop_pub IS 'Provenance. Any featureprop assignment can optionally be supported by a publication.';



create table feature_dbxref (
    feature_dbxref_id serial not null,
    primary key (feature_dbxref_id),
    feature_id int not null,
    foreign key (feature_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    dbxref_id int not null,
    foreign key (dbxref_id) references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED,
    is_current boolean not null default 'true',
    constraint feature_dbxref_c1 unique (feature_id,dbxref_id)
);
create index feature_dbxref_idx1 on feature_dbxref (feature_id);
create index feature_dbxref_idx2 on feature_dbxref (dbxref_id);

COMMENT ON TABLE feature_dbxref IS 'Links a feature to dbxrefs. This is for secondary identifiers; primary identifiers should use feature.dbxref_id.';

COMMENT ON COLUMN feature_dbxref.is_current IS 'True if this secondary dbxref is the most up to date accession in the corresponding db. Retired accessions should set this field to false';



create table feature_relationship (
    feature_relationship_id serial not null,
    primary key (feature_relationship_id),
    subject_id int not null,
    foreign key (subject_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    object_id int not null,
    foreign key (object_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value text null,
    rank int not null default 0,
    constraint feature_relationship_c1 unique (subject_id,object_id,type_id,rank)
);
create index feature_relationship_idx1 on feature_relationship (subject_id);
create index feature_relationship_idx2 on feature_relationship (object_id);
create index feature_relationship_idx3 on feature_relationship (type_id);

COMMENT ON TABLE feature_relationship IS 'Features can be arranged in
graphs, e.g. "exon part_of transcript part_of gene"; If type is
thought of as a verb, the each arc or edge makes a statement
[Subject Verb Object]. The object can also be thought of as parent
(containing feature), and subject as child (contained feature or
subfeature). We include the relationship rank/order, because even
though most of the time we can order things implicitly by sequence
coordinates, we can not always do this - e.g. transpliced genes. It is also
useful for quickly getting implicit introns.';

COMMENT ON COLUMN feature_relationship.subject_id IS 'The subject of the subj-predicate-obj sentence. This is typically the subfeature.';

COMMENT ON COLUMN feature_relationship.object_id IS 'The object of the subj-predicate-obj sentence. This is typically the container feature.';

COMMENT ON COLUMN feature_relationship.type_id IS 'Relationship type between subject and object. This is a cvterm, typically from the OBO relationship ontology, although other relationship types are allowed. The most common relationship type is OBO_REL:part_of. Valid relationship types are constrained by the Sequence Ontology.';

COMMENT ON COLUMN feature_relationship.rank IS 'The ordering of subject features with respect to the object feature may be important (for example, exon ordering on a transcript - not always derivable if you take trans spliced genes into consideration). Rank is used to order these; starts from zero.';

COMMENT ON COLUMN feature_relationship.value IS 'Additional notes or comments.';


 
create table feature_relationship_pub (
	feature_relationship_pub_id serial not null,
	primary key (feature_relationship_pub_id),
	feature_relationship_id int not null,
	foreign key (feature_relationship_id) references feature_relationship (feature_relationship_id) on delete cascade INITIALLY DEFERRED,
	pub_id int not null,
	foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    constraint feature_relationship_pub_c1 unique (feature_relationship_id,pub_id)
);
create index feature_relationship_pub_idx1 on feature_relationship_pub (feature_relationship_id);
create index feature_relationship_pub_idx2 on feature_relationship_pub (pub_id);

COMMENT ON TABLE feature_relationship_pub IS 'Provenance. Attach optional evidence to a feature_relationship in the form of a publication.';

 

create table feature_relationshipprop (
    feature_relationshipprop_id serial not null,
    primary key (feature_relationshipprop_id),
    feature_relationship_id int not null,
    foreign key (feature_relationship_id) references feature_relationship (feature_relationship_id) on delete cascade,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value text null,
    rank int not null default 0,
    constraint feature_relationshipprop_c1 unique (feature_relationship_id,type_id,rank)
);
create index feature_relationshipprop_idx1 on feature_relationshipprop (feature_relationship_id);
create index feature_relationshipprop_idx2 on feature_relationshipprop (type_id);

COMMENT ON TABLE feature_relationshipprop IS 'Extensible properties
for feature_relationships. Analagous structure to featureprop. This
table is largely optional and not used with a high frequency. Typical
scenarios may be if one wishes to attach additional data to a
feature_relationship - for example to say that the
feature_relationship is only true in certain contexts.';

COMMENT ON COLUMN feature_relationshipprop.type_id IS 'The name of the
property/slot is a cvterm. The meaning of the property is defined in
that cvterm. Currently there is no standard ontology for
feature_relationship property types.';

COMMENT ON COLUMN feature_relationshipprop.value IS 'The value of the
property, represented as text. Numeric values are converted to their
text representation. This is less efficient than using native database
types, but is easier to query.';

COMMENT ON COLUMN feature_relationshipprop.rank IS 'Property-Value
ordering. Any feature_relationship can have multiple values for any particular
property type - these are ordered in a list using rank, counting from
zero. For properties that are single-valued rather than multi-valued,
the default 0 value should be used.';


create table feature_relationshipprop_pub (
    feature_relationshipprop_pub_id serial not null,
    primary key (feature_relationshipprop_pub_id),
    feature_relationshipprop_id int not null,
    foreign key (feature_relationshipprop_id) references feature_relationshipprop (feature_relationshipprop_id) on delete cascade INITIALLY DEFERRED,
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    constraint feature_relationshipprop_pub_c1 unique (feature_relationshipprop_id,pub_id)
);
create index feature_relationshipprop_pub_idx1 on feature_relationshipprop_pub (feature_relationshipprop_id);
create index feature_relationshipprop_pub_idx2 on feature_relationshipprop_pub (pub_id);

COMMENT ON TABLE feature_relationshipprop_pub IS 'Provenance for feature_relationshipprop.';


create table feature_cvterm (
    feature_cvterm_id serial not null,
    primary key (feature_cvterm_id),
    feature_id int not null,
    foreign key (feature_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    cvterm_id int not null,
    foreign key (cvterm_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    is_not boolean not null default false,
    rank integer not null default 0,
    constraint feature_cvterm_c1 unique (feature_id,cvterm_id,pub_id,rank)
);
create index feature_cvterm_idx1 on feature_cvterm (feature_id);
create index feature_cvterm_idx2 on feature_cvterm (cvterm_id);
create index feature_cvterm_idx3 on feature_cvterm (pub_id);

COMMENT ON TABLE feature_cvterm IS 'Associate a term from a cv with a feature, for example, GO annotation.';

COMMENT ON COLUMN feature_cvterm.pub_id IS 'Provenance for the annotation. Each annotation should have a single primary publication (which may be of the appropriate type for computational analyses) where more details can be found. Additional provenance dbxrefs can be attached using feature_cvterm_dbxref.';

COMMENT ON COLUMN feature_cvterm.is_not IS 'If this is set to true, then this annotation is interpreted as a NEGATIVE annotation - i.e. the feature does NOT have the specified function, process, component, part, etc. See GO docs for more details.';



create table feature_cvtermprop (
    feature_cvtermprop_id serial not null,
    primary key (feature_cvtermprop_id),
    feature_cvterm_id int not null,
    foreign key (feature_cvterm_id) references feature_cvterm (feature_cvterm_id) on delete cascade,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value text null,
    rank int not null default 0,
    constraint feature_cvtermprop_c1 unique (feature_cvterm_id,type_id,rank)
);
create index feature_cvtermprop_idx1 on feature_cvtermprop (feature_cvterm_id);
create index feature_cvtermprop_idx2 on feature_cvtermprop (type_id);

COMMENT ON TABLE feature_cvtermprop IS 'Extensible properties for
feature to cvterm associations. Examples: GO evidence codes;
qualifiers; metadata such as the date on which the entry was curated
and the source of the association. See the featureprop table for
meanings of type_id, value and rank.';

COMMENT ON COLUMN feature_cvtermprop.type_id IS 'The name of the
property/slot is a cvterm. The meaning of the property is defined in
that cvterm. cvterms may come from the OBO evidence code cv.';

COMMENT ON COLUMN feature_cvtermprop.value IS 'The value of the
property, represented as text. Numeric values are converted to their
text representation. This is less efficient than using native database
types, but is easier to query.';

COMMENT ON COLUMN feature_cvtermprop.rank IS 'Property-Value
ordering. Any feature_cvterm can have multiple values for any particular
property type - these are ordered in a list using rank, counting from
zero. For properties that are single-valued rather than multi-valued,
the default 0 value should be used.';



create table feature_cvterm_dbxref (
    feature_cvterm_dbxref_id serial not null,
    primary key (feature_cvterm_dbxref_id),
    feature_cvterm_id int not null,
    foreign key (feature_cvterm_id) references feature_cvterm (feature_cvterm_id) on delete cascade,
    dbxref_id int not null,
    foreign key (dbxref_id) references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED,
    constraint feature_cvterm_dbxref_c1 unique (feature_cvterm_id,dbxref_id)
);
create index feature_cvterm_dbxref_idx1 on feature_cvterm_dbxref (feature_cvterm_id);
create index feature_cvterm_dbxref_idx2 on feature_cvterm_dbxref (dbxref_id);

COMMENT ON TABLE feature_cvterm_dbxref IS 'Additional dbxrefs for an association. Rows in the feature_cvterm table may be backed up by dbxrefs. For example, a feature_cvterm association that was inferred via a protein-protein interaction may be backed by by refering to the dbxref for the alternate protein. Corresponds to the WITH column in a GO gene association file (but can also be used for other analagous associations). See http://www.geneontology.org/doc/GO.annotation.shtml#file for more details.';


create table feature_cvterm_pub (
    feature_cvterm_pub_id serial not null,
    primary key (feature_cvterm_pub_id),
    feature_cvterm_id int not null,
    foreign key (feature_cvterm_id) references feature_cvterm (feature_cvterm_id) on delete cascade,
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    constraint feature_cvterm_pub_c1 unique (feature_cvterm_id,pub_id)
);
create index feature_cvterm_pub_idx1 on feature_cvterm_pub (feature_cvterm_id);
create index feature_cvterm_pub_idx2 on feature_cvterm_pub (pub_id);

COMMENT ON TABLE feature_cvterm_pub IS 'Secondary pubs for an
association. Each feature_cvterm association is supported by a single
primary publication. Additional secondary pubs can be added using this
linking table (in a GO gene association file, these corresponding to
any IDs after the pipe symbol in the publications column.';


create table synonym (
    synonym_id serial not null,
    primary key (synonym_id),
    name varchar(255) not null,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    synonym_sgml varchar(255) not null,
    constraint synonym_c1 unique (name,type_id)
);
create index synonym_idx1 on synonym (type_id);
create index synonym_idx2 on synonym ((lower(synonym_sgml)));

COMMENT ON TABLE synonym IS 'A synonym for a feature. One feature can have multiple synonyms, and the same synonym can apply to multiple features.';

COMMENT ON COLUMN synonym.name IS 'The synonym itself. Should be human-readable machine-searchable ascii text.';

COMMENT ON COLUMN synonym.synonym_sgml IS 'The fully specified synonym, with any non-ascii characters encoded in SGML.';

COMMENT ON COLUMN synonym.type_id IS 'Types would be symbol and fullname for now.';



create table feature_synonym (
    feature_synonym_id serial not null,
    primary key (feature_synonym_id),
    synonym_id int not null,
    foreign key (synonym_id) references synonym (synonym_id) on delete cascade INITIALLY DEFERRED,
    feature_id int not null,
    foreign key (feature_id) references feature (feature_id) on delete cascade INITIALLY DEFERRED,
    pub_id int not null,
    foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
    is_current boolean not null default 'false',
    is_internal boolean not null default 'false',
    constraint feature_synonym_c1 unique (synonym_id,feature_id,pub_id)
);
create index feature_synonym_idx1 on feature_synonym (synonym_id);
create index feature_synonym_idx2 on feature_synonym (feature_id);
create index feature_synonym_idx3 on feature_synonym (pub_id);

COMMENT ON TABLE feature_synonym IS 'Linking table between feature and synonym.';

COMMENT ON COLUMN feature_synonym.pub_id IS 'The pub_id link is for relating the usage of a given synonym to the publication in which it was used.';

COMMENT ON COLUMN feature_synonym.is_current IS 'The is_current boolean indicates whether the linked synonym is the  current -official- symbol for the linked feature.';

COMMENT ON COLUMN feature_synonym.is_internal IS 'Typically a synonym exists so that somebody querying the db with an obsolete name can find the object theyre looking for (under its current name.  If the synonym has been used publicly and deliberately (e.g. in a paper), it may also be listed in reports as a synonym. If the synonym was not used deliberately (e.g. there was a typo which went public), then the is_internal boolean may be set to -true- so that it is known that the synonym is -internal- and should be queryable but should not be listed in reports as a valid synonym.';
-- ######################################################
-- module contact
-- ######################################################


create table contact (
    contact_id serial not null,
    primary key (contact_id),
    type_id int null,
    foreign key (type_id) references cvterm (cvterm_id),
    name varchar(255) not null,
    description varchar(255) null,
    constraint contact_c1 unique (name)
);

COMMENT ON TABLE contact IS 'Model persons, institutes, groups, organizations, etc.';
COMMENT ON COLUMN contact.type_id IS 'What type of contact is this?  E.g. "person", "lab".';


create table contact_relationship (
    contact_relationship_id serial not null,
    primary key (contact_relationship_id),
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    subject_id int not null,
    foreign key (subject_id) references contact (contact_id) on delete cascade INITIALLY DEFERRED,
    object_id int not null,
    foreign key (object_id) references contact (contact_id) on delete cascade INITIALLY DEFERRED,
    constraint contact_relationship_c1 unique (subject_id,object_id,type_id)
);
create index contact_relationship_idx1 on contact_relationship (type_id);
create index contact_relationship_idx2 on contact_relationship (subject_id);
create index contact_relationship_idx3 on contact_relationship (object_id);

COMMENT ON TABLE contact_relationship IS 'Model relationships between contacts';
COMMENT ON COLUMN contact_relationship.subject_id IS 'The subject of the subj-predicate-obj sentence. In a DAG, this corresponds to the child node.';
COMMENT ON COLUMN contact_relationship.object_id IS 'The object of the subj-predicate-obj sentence. In a DAG, this corresponds to the parent node.';
COMMENT ON COLUMN contact_relationship.type_id IS 'Relationship type between subject and object. This is a cvterm, typically from the OBO relationship ontology, although other relationship types are allowed.';
-- ######################################################
-- module project
-- ######################################################



create table project (
    project_id serial not null,  
    primary key (project_id),
    name varchar(255) not null,
    description varchar(255) not null,
    constraint project_c1 unique (name)
);

COMMENT ON TABLE project IS NULL;


CREATE TABLE projectprop (
	projectprop_id serial NOT NULL,
	PRIMARY KEY (projectprop_id),
	project_id integer NOT NULL,
	FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE,
	cvterm_id integer NOT NULL,
	FOREIGN KEY (cvterm_id) REFERENCES cvterm (cvterm_id) ON DELETE CASCADE,
	value text,
	rank integer not null default 0,
	CONSTRAINT projectprop_c1 UNIQUE (project_id, cvterm_id, rank)
);


CREATE TABLE project_relationship (
	project_relationship_id serial NOT NULL,
	PRIMARY KEY (project_relationship_id),
	subject_project_id integer NOT NULL,
	FOREIGN KEY (subject_project_id) REFERENCES project (project_id) ON DELETE CASCADE,
	object_project_id integer NOT NULL,
	FOREIGN KEY (object_project_id) REFERENCES project (project_id) ON DELETE CASCADE,
	type_id integer NOT NULL,
	FOREIGN KEY (type_id) REFERENCES cvterm (cvterm_id) ON DELETE RESTRICT,
	CONSTRAINT project_relationship_c1 UNIQUE (subject_project_id, object_project_id, type_id)
);
COMMENT ON TABLE project_relationship IS 'A project can be composed of several smaller scale projects';
COMMENT ON COLUMN project_relationship.type_id IS 'The type of relationship being stated, such as "is part of".';


create table project_pub (
       project_pub_id serial not null,
       primary key (project_pub_id),
       project_id int not null,
       foreign key (project_id) references project (project_id) on delete cascade INITIALLY DEFERRED,
       pub_id int not null,
       foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
       constraint project_pub_c1 unique (project_id,pub_id)
);
create index project_pub_idx1 on project_pub (project_id);
create index project_pub_idx2 on project_pub (pub_id);

COMMENT ON TABLE project_pub IS 'Linking project(s) to publication(s)';


create table project_contact (
       project_contact_id serial not null,
       primary key (project_contact_id),
       project_id int not null,
       foreign key (project_id) references project (project_id) on delete cascade INITIALLY DEFERRED,
       contact_id int not null,
       foreign key (contact_id) references contact (contact_id) on delete cascade INITIALLY DEFERRED,
       constraint project_contact_c1 unique (project_id,contact_id)
);
create index project_contact_idx1 on project_contact (project_id);
create index project_contact_idx2 on project_contact (contact_id);

COMMENT ON TABLE project_contact IS 'Linking project(s) to contact(s)';
-- ######################################################
-- module phenotype
-- ######################################################



CREATE TABLE phenotype (
    phenotype_id SERIAL NOT NULL,
    primary key (phenotype_id),
    uniquename TEXT NOT NULL,  
    observable_id INT,
    FOREIGN KEY (observable_id) REFERENCES cvterm (cvterm_id) ON DELETE CASCADE,
    attr_id INT,
    FOREIGN KEY (attr_id) REFERENCES cvterm (cvterm_id) ON DELETE SET NULL,
    value TEXT,
    cvalue_id INT,
    FOREIGN KEY (cvalue_id) REFERENCES cvterm (cvterm_id) ON DELETE SET NULL,
    assay_id INT,
    FOREIGN KEY (assay_id) REFERENCES cvterm (cvterm_id) ON DELETE SET NULL,
    CONSTRAINT phenotype_c1 UNIQUE (uniquename)
);
CREATE INDEX phenotype_idx1 ON phenotype (cvalue_id);
CREATE INDEX phenotype_idx2 ON phenotype (observable_id);
CREATE INDEX phenotype_idx3 ON phenotype (attr_id);

COMMENT ON TABLE phenotype IS 'A phenotypic statement, or a single
atomic phenotypic observation, is a controlled sentence describing
observable effects of non-wild type function. E.g. Obs=eye, attribute=color, cvalue=red.';
COMMENT ON COLUMN phenotype.observable_id IS 'The entity: e.g. anatomy_part, biological_process.';
COMMENT ON COLUMN phenotype.attr_id IS 'Phenotypic attribute (quality, property, attribute, character) - drawn from PATO.';
COMMENT ON COLUMN phenotype.value IS 'Value of attribute - unconstrained free text. Used only if cvalue_id is not appropriate.';
COMMENT ON COLUMN phenotype.cvalue_id IS 'Phenotype attribute value (state).';
COMMENT ON COLUMN phenotype.assay_id IS 'Evidence type.';


CREATE TABLE phenotype_cvterm (
    phenotype_cvterm_id SERIAL NOT NULL,
    primary key (phenotype_cvterm_id),
    phenotype_id INT NOT NULL,
    FOREIGN KEY (phenotype_id) REFERENCES phenotype (phenotype_id) ON DELETE CASCADE,
    cvterm_id INT NOT NULL,
    FOREIGN KEY (cvterm_id) REFERENCES cvterm (cvterm_id) ON DELETE CASCADE,
    rank int not null default 0,
    CONSTRAINT phenotype_cvterm_c1 UNIQUE (phenotype_id, cvterm_id, rank)
);
CREATE INDEX phenotype_cvterm_idx1 ON phenotype_cvterm (phenotype_id);
CREATE INDEX phenotype_cvterm_idx2 ON phenotype_cvterm (cvterm_id);

COMMENT ON TABLE phenotype_cvterm IS NULL;


CREATE TABLE feature_phenotype (
    feature_phenotype_id SERIAL NOT NULL,
    primary key (feature_phenotype_id),
    feature_id INT NOT NULL,
    FOREIGN KEY (feature_id) REFERENCES feature (feature_id) ON DELETE CASCADE,
    phenotype_id INT NOT NULL,
    FOREIGN KEY (phenotype_id) REFERENCES phenotype (phenotype_id) ON DELETE CASCADE,
    CONSTRAINT feature_phenotype_c1 UNIQUE (feature_id,phenotype_id)       
);
CREATE INDEX feature_phenotype_idx1 ON feature_phenotype (feature_id);
CREATE INDEX feature_phenotype_idx2 ON feature_phenotype (phenotype_id);

COMMENT ON TABLE feature_phenotype IS NULL;
-- ######################################################
-- module genetic
-- ######################################################

create table genotype (
    genotype_id serial not null,
    primary key (genotype_id),
    name text,
    uniquename text not null,      
    description varchar(255),
    constraint genotype_c1 unique (uniquename)
);
create index genotype_idx1 on genotype(uniquename);
create index genotype_idx2 on genotype(name);

COMMENT ON TABLE genotype IS 'Genetic context. A genotype is defined by a collection of features, mutations, balancers, deficiencies, haplotype blocks, or engineered constructs.';

COMMENT ON COLUMN genotype.uniquename IS 'The unique name for a genotype; 
typically derived from the features making up the genotype.';

COMMENT ON COLUMN genotype.name IS 'Optional alternative name for a genotype, 
for display purposes.';

create table feature_genotype (
    feature_genotype_id serial not null,
    primary key (feature_genotype_id),
    feature_id int not null,
    foreign key (feature_id) references feature (feature_id) on delete cascade,
    genotype_id int not null,
    foreign key (genotype_id) references genotype (genotype_id) on delete cascade,
    chromosome_id int,
    foreign key (chromosome_id) references feature (feature_id) on delete set null,
    rank int not null,
    cgroup    int not null,
    cvterm_id int not null,
    foreign key (cvterm_id) references cvterm (cvterm_id) on delete cascade,
    constraint feature_genotype_c1 unique (feature_id, genotype_id, cvterm_id, chromosome_id, rank, cgroup)
);
create index feature_genotype_idx1 on feature_genotype (feature_id);
create index feature_genotype_idx2 on feature_genotype (genotype_id);

COMMENT ON TABLE feature_genotype IS NULL;
COMMENT ON COLUMN feature_genotype.rank IS 'rank can be used for
n-ploid organisms or to preserve order.';
COMMENT ON COLUMN feature_genotype.cgroup IS 'Spatially distinguishable
group. group can be used for distinguishing the chromosomal groups,
for example (RNAi products and so on can be treated as different
groups, as they do not fall on a particular chromosome).';
COMMENT ON COLUMN feature_genotype.chromosome_id IS 'A feature of SO type "chromosome".';

create table environment (
    environment_id serial not NULL,
    primary key  (environment_id),
    uniquename text not null,
    description text,
    constraint environment_c1 unique (uniquename)
);
create index environment_idx1 on environment(uniquename);

COMMENT ON TABLE environment IS 'The environmental component of a phenotype description.';


create table environment_cvterm (
    environment_cvterm_id serial not null,
    primary key  (environment_cvterm_id),
    environment_id int not null,
    foreign key (environment_id) references environment (environment_id) on delete cascade,
    cvterm_id int not null,
    foreign key (cvterm_id) references cvterm (cvterm_id) on delete cascade,
    constraint environment_cvterm_c1 unique (environment_id, cvterm_id)
);
create index environment_cvterm_idx1 on environment_cvterm (environment_id);
create index environment_cvterm_idx2 on environment_cvterm (cvterm_id);

COMMENT ON TABLE environment_cvterm IS NULL;

CREATE TABLE phenstatement (
    phenstatement_id SERIAL NOT NULL,
    primary key (phenstatement_id),
    genotype_id INT NOT NULL,
    FOREIGN KEY (genotype_id) REFERENCES genotype (genotype_id) ON DELETE CASCADE,
    environment_id INT NOT NULL,
    FOREIGN KEY (environment_id) REFERENCES environment (environment_id) ON DELETE CASCADE,
    phenotype_id INT NOT NULL,
    FOREIGN KEY (phenotype_id) REFERENCES phenotype (phenotype_id) ON DELETE CASCADE,
    type_id INT NOT NULL,
    FOREIGN KEY (type_id) REFERENCES cvterm (cvterm_id) ON DELETE CASCADE,
    pub_id INT NOT NULL,
    FOREIGN KEY (pub_id) REFERENCES pub (pub_id) ON DELETE CASCADE,
    CONSTRAINT phenstatement_c1 UNIQUE (genotype_id,phenotype_id,environment_id,type_id,pub_id)
);
CREATE INDEX phenstatement_idx1 ON phenstatement (genotype_id);
CREATE INDEX phenstatement_idx2 ON phenstatement (phenotype_id);

COMMENT ON TABLE phenstatement IS 'Phenotypes are things like "larval lethal".  Phenstatements are things like "dpp-1 is recessive larval lethal". So essentially phenstatement is a linking table expressing the relationship between genotype, environment, and phenotype.';

CREATE TABLE phendesc (
    phendesc_id SERIAL NOT NULL,
    primary key (phendesc_id),
    genotype_id INT NOT NULL,
    FOREIGN KEY (genotype_id) REFERENCES genotype (genotype_id) ON DELETE CASCADE,
    environment_id INT NOT NULL,
    FOREIGN KEY (environment_id) REFERENCES environment ( environment_id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    type_id INT NOT NULL,
        FOREIGN KEY (type_id) REFERENCES cvterm (cvterm_id) ON DELETE CASCADE,
    pub_id INT NOT NULL,
    FOREIGN KEY (pub_id) REFERENCES pub (pub_id) ON DELETE CASCADE,
    CONSTRAINT phendesc_c1 UNIQUE (genotype_id,environment_id,type_id,pub_id)
);
CREATE INDEX phendesc_idx1 ON phendesc (genotype_id);
CREATE INDEX phendesc_idx2 ON phendesc (environment_id);
CREATE INDEX phendesc_idx3 ON phendesc (pub_id);

COMMENT ON TABLE phendesc IS 'A summary of a _set_ of phenotypic statements for any one gcontext made in any one publication.';

CREATE TABLE phenotype_comparison (
    phenotype_comparison_id SERIAL NOT NULL,
    primary key (phenotype_comparison_id),
    genotype1_id INT NOT NULL,
        FOREIGN KEY (genotype1_id) REFERENCES genotype (genotype_id) ON DELETE CASCADE,
    environment1_id INT NOT NULL,
        FOREIGN KEY (environment1_id) REFERENCES environment (environment_id) ON DELETE CASCADE,
    genotype2_id INT NOT NULL,
        FOREIGN KEY (genotype2_id) REFERENCES genotype (genotype_id) ON DELETE CASCADE,
    environment2_id INT NOT NULL,
        FOREIGN KEY (environment2_id) REFERENCES environment (environment_id) ON DELETE CASCADE,
    phenotype1_id INT NOT NULL,
        FOREIGN KEY (phenotype1_id) REFERENCES phenotype (phenotype_id) ON DELETE CASCADE,
    phenotype2_id INT,
        FOREIGN KEY (phenotype2_id) REFERENCES phenotype (phenotype_id) ON DELETE CASCADE,
    pub_id INT NOT NULL,
    FOREIGN KEY (pub_id) REFERENCES pub (pub_id) ON DELETE CASCADE,
    organism_id INT NOT NULL,
    FOREIGN KEY (organism_id) REFERENCES organism (organism_id) ON DELETE CASCADE,
    CONSTRAINT phenotype_comparison_c1 UNIQUE (genotype1_id,environment1_id,genotype2_id,environment2_id,phenotype1_id,pub_id)
);
CREATE INDEX phenotype_comparison_idx1 on phenotype_comparison (genotype1_id);
CREATE INDEX phenotype_comparison_idx2 on phenotype_comparison (genotype2_id);
CREATE INDEX phenotype_comparison_idx4 on phenotype_comparison (pub_id);

COMMENT ON TABLE phenotype_comparison IS 'Comparison of phenotypes e.g., genotype1/environment1/phenotype1 "non-suppressible" with respect to genotype2/environment2/phenotype2.';

CREATE TABLE phenotype_comparison_cvterm (
    phenotype_comparison_cvterm_id serial not null,
    primary key (phenotype_comparison_cvterm_id),
    phenotype_comparison_id int not null,
    FOREIGN KEY (phenotype_comparison_id) references phenotype_comparison (phenotype_comparison_id) on delete cascade,
    cvterm_id int not null,
    FOREIGN KEY (cvterm_id) references cvterm (cvterm_id) on delete cascade,
    pub_id INT not null,
    FOREIGN KEY (pub_id) references pub (pub_id) on delete cascade,
    rank int not null default 0,
    CONSTRAINT phenotype_comparison_cvterm_c1 unique (phenotype_comparison_id, cvterm_id)
);
CREATE INDEX phenotype_comparison_cvterm_idx1 on phenotype_comparison_cvterm (phenotype_comparison_id);
CREATE INDEX  phenotype_comparison_cvterm_idx2 on phenotype_comparison_cvterm (cvterm_id);
-- ######################################################
-- module stock
-- ######################################################


create table stock (
       stock_id serial not null,
       primary key (stock_id),
       dbxref_id int,
       foreign key (dbxref_id) references dbxref (dbxref_id) on delete set null INITIALLY DEFERRED,
       organism_id int,
       foreign key (organism_id) references organism (organism_id) on delete cascade INITIALLY DEFERRED,
       name varchar(255),
       uniquename text not null,
       description text,
       type_id int not null,
       foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
       is_obsolete boolean not null default 'false',
       constraint stock_c1 unique (organism_id,uniquename,type_id)
);
create index stock_name_ind1 on stock (name);
create index stock_idx1 on stock (dbxref_id);
create index stock_idx2 on stock (organism_id);
create index stock_idx3 on stock (type_id);
create index stock_idx4 on stock (uniquename);

COMMENT ON TABLE stock IS 'Any stock can be globally identified by the
combination of organism, uniquename and stock type. A stock is the physical entities, either living or preserved, held by collections. Stocks belong to a collection; they have IDs, type, organism, description and may have a genotype.';
COMMENT ON COLUMN stock.dbxref_id IS 'The dbxref_id is an optional primary stable identifier for this stock. Secondary indentifiers and external dbxrefs go in table: stock_dbxref.';
COMMENT ON COLUMN stock.organism_id IS 'The organism_id is the organism to which the stock belongs. This column should only be left blank if the organism cannot be determined.';
COMMENT ON COLUMN stock.type_id IS 'The type_id foreign key links to a controlled vocabulary of stock types. The would include living stock, genomic DNA, preserved specimen. Secondary cvterms for stocks would go in stock_cvterm.';
COMMENT ON COLUMN stock.description IS 'The description is the genetic description provided in the stock list.';
COMMENT ON COLUMN stock.name IS 'The name is a human-readable local name for a stock.';



create table stock_pub (
       stock_pub_id serial not null,
       primary key (stock_pub_id),
       stock_id int not null,
       foreign key (stock_id) references stock (stock_id)  on delete cascade INITIALLY DEFERRED,
       pub_id int not null,
       foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
       constraint stock_pub_c1 unique (stock_id,pub_id)
);
create index stock_pub_idx1 on stock_pub (stock_id);
create index stock_pub_idx2 on stock_pub (pub_id);

COMMENT ON TABLE stock_pub IS 'Provenance. Linking table between stocks and, for example, a stocklist computer file.';



create table stockprop (
       stockprop_id serial not null,
       primary key (stockprop_id),
       stock_id int not null,
       foreign key (stock_id) references stock (stock_id) on delete cascade INITIALLY DEFERRED,
       type_id int not null,
       foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
       value text null,
       rank int not null default 0,
       constraint stockprop_c1 unique (stock_id,type_id,rank)
);
create index stockprop_idx1 on stockprop (stock_id);
create index stockprop_idx2 on stockprop (type_id);

COMMENT ON TABLE stockprop IS 'A stock can have any number of
slot-value property tags attached to it. This is an alternative to
hardcoding a list of columns in the relational schema, and is
completely extensible. There is a unique constraint, stockprop_c1, for
the combination of stock_id, rank, and type_id. Multivalued property-value pairs must be differentiated by rank.';



create table stockprop_pub (
     stockprop_pub_id serial not null,
     primary key (stockprop_pub_id),
     stockprop_id int not null,
     foreign key (stockprop_id) references stockprop (stockprop_id) on delete cascade INITIALLY DEFERRED,
     pub_id int not null,
     foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
     constraint stockprop_pub_c1 unique (stockprop_id,pub_id)
);
create index stockprop_pub_idx1 on stockprop_pub (stockprop_id);
create index stockprop_pub_idx2 on stockprop_pub (pub_id); 

COMMENT ON TABLE stockprop_pub IS 'Provenance. Any stockprop assignment can optionally be supported by a publication.';



create table stock_relationship (
       stock_relationship_id serial not null,
       primary key (stock_relationship_id),
       subject_id int not null,
       foreign key (subject_id) references stock (stock_id) on delete cascade INITIALLY DEFERRED,
       object_id int not null,
       foreign key (object_id) references stock (stock_id) on delete cascade INITIALLY DEFERRED,
       type_id int not null,
       foreign key (type_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
       value text null,
       rank int not null default 0,
       constraint stock_relationship_c1 unique (subject_id,object_id,type_id,rank)
);
create index stock_relationship_idx1 on stock_relationship (subject_id);
create index stock_relationship_idx2 on stock_relationship (object_id);
create index stock_relationship_idx3 on stock_relationship (type_id);

COMMENT ON COLUMN stock_relationship.subject_id IS 'stock_relationship.subject_id is the subject of the subj-predicate-obj sentence. This is typically the substock.';
COMMENT ON COLUMN stock_relationship.object_id IS 'stock_relationship.object_id is the object of the subj-predicate-obj sentence. This is typically the container stock.';
COMMENT ON COLUMN stock_relationship.type_id IS 'stock_relationship.type_id is relationship type between subject and object. This is a cvterm, typically from the OBO relationship ontology, although other relationship types are allowed.';
COMMENT ON COLUMN stock_relationship.rank IS 'stock_relationship.rank is the ordering of subject stocks with respect to the object stock may be important where rank is used to order these; starts from zero.';
COMMENT ON COLUMN stock_relationship.value IS 'stock_relationship.value is for additional notes or comments.';




CREATE TABLE stock_relationship_cvterm (
	stock_relationship_cvterm_id SERIAL NOT NULL,
	PRIMARY KEY (stock_relationship_cvterm_id),
	stock_relatiohship_id integer NOT NULL,
	--FOREIGN KEY (stock_relationship_id) references stock_relationship (stock_relationship_id) ON DELETE CASCADE INITIALLY DEFERRED,
	cvterm_id integer NOT NULL,
	FOREIGN KEY (cvterm_id) REFERENCES cvterm (cvterm_id) ON DELETE RESTRICT,
	pub_id integer,
	FOREIGN KEY (pub_id) REFERENCES pub (pub_id) ON DELETE RESTRICT
);
COMMENT ON TABLE stock_relationship_cvterm is 'For germplasm maintenance and pedigree data, stock_relationship. type_id will record cvterms such as "is a female parent of", "a parent for mutation", "is a group_id of", "is a source_id of", etc The cvterms for higher categories such as "generative", "derivative" or "maintenance" can be stored in table stock_relationship_cvterm';



create table stock_relationship_pub (
      stock_relationship_pub_id serial not null,
      primary key (stock_relationship_pub_id),
      stock_relationship_id integer not null,
      foreign key (stock_relationship_id) references stock_relationship (stock_relationship_id) on delete cascade INITIALLY DEFERRED,
      pub_id int not null,
      foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
      constraint stock_relationship_pub_c1 unique (stock_relationship_id,pub_id)
);
create index stock_relationship_pub_idx1 on stock_relationship_pub (stock_relationship_id);
create index stock_relationship_pub_idx2 on stock_relationship_pub (pub_id);

COMMENT ON TABLE stock_relationship_pub IS 'Provenance. Attach optional evidence to a stock_relationship in the form of a publication.';



create table stock_dbxref (
     stock_dbxref_id serial not null,
     primary key (stock_dbxref_id),
     stock_id int not null,
     foreign key (stock_id) references stock (stock_id) on delete cascade INITIALLY DEFERRED,
     dbxref_id int not null,
     foreign key (dbxref_id) references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED,
     is_current boolean not null default 'true',
     constraint stock_dbxref_c1 unique (stock_id,dbxref_id)
);
create index stock_dbxref_idx1 on stock_dbxref (stock_id);
create index stock_dbxref_idx2 on stock_dbxref (dbxref_id);

COMMENT ON TABLE stock_dbxref IS 'stock_dbxref links a stock to dbxrefs. This is for secondary identifiers; primary identifiers should use stock.dbxref_id.';
COMMENT ON COLUMN stock_dbxref.is_current IS 'The is_current boolean indicates whether the linked dbxref is the current -official- dbxref for the linked stock.';



create table stock_cvterm (
     stock_cvterm_id serial not null,
     primary key (stock_cvterm_id),
     stock_id int not null,
     foreign key (stock_id) references stock (stock_id) on delete cascade INITIALLY DEFERRED,
     cvterm_id int not null,
     foreign key (cvterm_id) references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
     pub_id int not null,
     foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
     constraint stock_cvterm_c1 unique (stock_id,cvterm_id,pub_id)
);
create index stock_cvterm_idx1 on stock_cvterm (stock_id);
create index stock_cvterm_idx2 on stock_cvterm (cvterm_id);
create index stock_cvterm_idx3 on stock_cvterm (pub_id);

COMMENT ON TABLE stock_cvterm IS 'stock_cvterm links a stock to cvterms. This is for secondary cvterms; primary cvterms should use stock.type_id.';



create table stock_genotype (
       stock_genotype_id serial not null,
       primary key (stock_genotype_id),
       stock_id int not null,
       foreign key (stock_id) references stock (stock_id) on delete cascade,
       genotype_id int not null,
       foreign key (genotype_id) references genotype (genotype_id) on delete cascade,
       constraint stock_genotype_c1 unique (stock_id, genotype_id)
);
create index stock_genotype_idx1 on stock_genotype (stock_id);
create index stock_genotype_idx2 on stock_genotype (genotype_id);

COMMENT ON TABLE stock_genotype IS 'Simple table linking a stock to
a genotype. Features with genotypes can be linked to stocks thru feature_genotype -> genotype -> stock_genotype -> stock.';



create table stockcollection (
	stockcollection_id serial not null, 
        primary key (stockcollection_id),
	type_id int not null,
        foreign key (type_id) references cvterm (cvterm_id) on delete cascade,
        contact_id int null,
        foreign key (contact_id) references contact (contact_id) on delete set null INITIALLY DEFERRED,
	name varchar(255),
	uniquename text not null,
	constraint stockcollection_c1 unique (uniquename,type_id)
);
create index stockcollection_name_ind1 on stockcollection (name);
create index stockcollection_idx1 on stockcollection (contact_id);
create index stockcollection_idx2 on stockcollection (type_id);
create index stockcollection_idx3 on stockcollection (uniquename);

COMMENT ON TABLE stockcollection IS 'The lab or stock center distributing the stocks in their collection.';
COMMENT ON COLUMN stockcollection.uniquename IS 'uniqename is the value of the collection cv.';
COMMENT ON COLUMN stockcollection.type_id IS 'type_id is the collection type cv.';
COMMENT ON COLUMN stockcollection.name IS 'name is the collection.';
COMMENT ON COLUMN stockcollection.contact_id IS 'contact_id links to the contact information for the collection.';



create table stockcollectionprop (
    stockcollectionprop_id serial not null,
    primary key (stockcollectionprop_id),
    stockcollection_id int not null,
    foreign key (stockcollection_id) references stockcollection (stockcollection_id) on delete cascade INITIALLY DEFERRED,
    type_id int not null,
    foreign key (type_id) references cvterm (cvterm_id),
    value text null,
    rank int not null default 0,
    constraint stockcollectionprop_c1 unique (stockcollection_id,type_id,rank)
);
create index stockcollectionprop_idx1 on stockcollectionprop (stockcollection_id);
create index stockcollectionprop_idx2 on stockcollectionprop (type_id);

COMMENT ON TABLE stockcollectionprop IS 'The table stockcollectionprop
contains the value of the stock collection such as website/email URLs;
the value of the stock collection order URLs.';
COMMENT ON COLUMN stockcollectionprop.type_id IS 'The cv for the type_id is "stockcollection property type".';



create table stockcollection_stock (
    stockcollection_stock_id serial not null,
    primary key (stockcollection_stock_id),
    stockcollection_id int not null,
    foreign key (stockcollection_id) references stockcollection (stockcollection_id) on delete cascade INITIALLY DEFERRED,
    stock_id int not null,
    foreign key (stock_id) references stock (stock_id) on delete cascade INITIALLY DEFERRED,
    constraint stockcollection_stock_c1 unique (stockcollection_id,stock_id)
);
create index stockcollection_stock_idx1 on stockcollection_stock (stockcollection_id);
create index stockcollection_stock_idx2 on stockcollection_stock (stock_id);

COMMENT ON TABLE stockcollection_stock IS 'stockcollection_stock links
a stock collection to the stocks which are contained in the collection.';
-- ######################################################
-- module natural_diversity/natural_diversity.sql
-- ######################################################



CREATE TABLE nd_geolocation (
    nd_geolocation_id serial PRIMARY KEY NOT NULL,
    description character varying(255),
    latitude real,
    longitude real,
    geodetic_datum character varying(32),
    altitude real
);

COMMENT ON TABLE nd_geolocation IS 'The geo-referencable location of the stock. NOTE: This entity is subject to change as a more general and possibly more OpenGIS-compliant geolocation module may be introduced into Chado.';

COMMENT ON COLUMN nd_geolocation.description IS 'A textual representation of the location, if this is the original georeference. Optional if the original georeference is available in lat/long coordinates.';


COMMENT ON COLUMN nd_geolocation.latitude IS 'The decimal latitude coordinate of the georeference, using positive and negative sign to indicate N and S, respectively.';

COMMENT ON COLUMN nd_geolocation.longitude IS 'The decimal longitude coordinate of the georeference, using positive and negative sign to indicate E and W, respectively.';

COMMENT ON COLUMN nd_geolocation.geodetic_datum IS 'The geodetic system on which the geo-reference coordinates are based. For geo-references measured between 1984 and 2010, this will typically be WGS84.';

COMMENT ON COLUMN nd_geolocation.altitude IS 'The altitude (elevation) of the location in meters. If the altitude is only known as a range, this is the average, and altitude_dev will hold half of the width of the range.';



CREATE TABLE nd_experiment (
    nd_experiment_id serial PRIMARY KEY NOT NULL,
    nd_geolocation_id integer NOT NULL references nd_geolocation (nd_geolocation_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED 
);

CREATE TABLE nd_experiment_project (
    nd_experiment_project_id serial PRIMARY KEY NOT NULL,
    project_id integer not null references project (project_id) on delete cascade INITIALLY DEFERRED,
    nd_experiment_id integer NOT NULL references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED
);



CREATE TABLE nd_experimentprop (
    nd_experimentprop_id serial PRIMARY KEY NOT NULL,
    nd_experiment_id integer NOT NULL references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED ,
    value character varying(255) NOT NULL,
    rank integer NOT NULL default 0,
    constraint nd_experimentprop_c1 unique (nd_experiment_id,type_id,rank)
);

create table nd_experiment_pub (
       nd_experiment_pub_id serial PRIMARY KEY not null,
       nd_experiment_id int not null,
       foreign key (nd_experiment_id) references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
       pub_id int not null,
       foreign key (pub_id) references pub (pub_id) on delete cascade INITIALLY DEFERRED,
       constraint nd_experiment_pub_c1 unique (nd_experiment_id,pub_id)
);
create index nd_experiment_pub_idx1 on nd_experiment_pub (nd_experiment_id);
create index nd_experiment_pub_idx2 on nd_experiment_pub (pub_id);

COMMENT ON TABLE nd_experiment_pub IS 'Linking nd_experiment(s) to publication(s)';




CREATE TABLE nd_geolocationprop (
    nd_geolocationprop_id serial PRIMARY KEY NOT NULL,
    nd_geolocation_id integer NOT NULL references nd_geolocation (nd_geolocation_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value character varying(250),
    rank integer NOT NULL DEFAULT 0,
    constraint nd_geolocationprop_c1 unique (nd_geolocation_id,type_id,rank)
);

COMMENT ON TABLE nd_geolocationprop IS 'Property/value associations for geolocations. This table can store the properties such as location and environment';

COMMENT ON COLUMN nd_geolocationprop.type_id IS 'The name of the property as a reference to a controlled vocabulary term.';

COMMENT ON COLUMN nd_geolocationprop.value IS 'The value of the property.';

COMMENT ON COLUMN nd_geolocationprop.rank IS 'The rank of the property value, if the property has an array of values.';


CREATE TABLE nd_protocol (
    nd_protocol_id serial PRIMARY KEY  NOT NULL,
    name character varying(255) NOT NULL unique
);

COMMENT ON TABLE nd_protocol IS 'A protocol can be anything that is done as part of the experiment.';

COMMENT ON COLUMN nd_protocol.name IS 'The protocol name.';

CREATE TABLE nd_reagent (
    nd_reagent_id serial PRIMARY KEY NOT NULL,
    name character varying(80) NOT NULL,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    feature_id integer
);

COMMENT ON TABLE nd_reagent IS 'A reagent such as a primer, an enzyme, an adapter oligo, a linker oligo. Reagents are used in genotyping experiments, or in any other kind of experiment.';

COMMENT ON COLUMN nd_reagent.name IS 'The name of the reagent. The name should be unique for a given type.';

COMMENT ON COLUMN nd_reagent.type_id IS 'The type of the reagent, for example linker oligomer, or forward primer.';

COMMENT ON COLUMN nd_reagent.feature_id IS 'If the reagent is a primer, the feature that it corresponds to. More generally, the corresponding feature for any reagent that has a sequence that maps to another sequence.';



CREATE TABLE nd_protocol_reagent (
    nd_protocol_reagent_id serial PRIMARY KEY NOT NULL,
    nd_protocol_id integer NOT NULL references nd_protocol (nd_protocol_id) on delete cascade INITIALLY DEFERRED,
    reagent_id integer NOT NULL references nd_reagent (nd_reagent_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED
);


CREATE TABLE nd_protocolprop (
    nd_protocolprop_id serial PRIMARY KEY NOT NULL,
    nd_protocol_id integer NOT NULL references nd_protocol (nd_protocol_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value character varying(255),
    rank integer DEFAULT 0 NOT NULL,
    constraint nd_protocolprop_c1 unique (nd_protocol_id,type_id,rank)
);

COMMENT ON TABLE nd_protocolprop IS 'Property/value associations for protocol.';

COMMENT ON COLUMN nd_protocolprop.nd_protocol_id IS 'The protocol to which the property applies.';

COMMENT ON COLUMN nd_protocolprop.type_id IS 'The name of the property as a reference to a controlled vocabulary term.';

COMMENT ON COLUMN nd_protocolprop.value IS 'The value of the property.';

COMMENT ON COLUMN nd_protocolprop.rank IS 'The rank of the property value, if the property has an array of values.';



CREATE TABLE nd_experiment_stock (
    nd_experiment_stock_id serial PRIMARY KEY NOT NULL,
    nd_experiment_id integer NOT NULL references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
    stock_id integer NOT NULL references stock (stock_id)  on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED
);

COMMENT ON TABLE nd_experiment_stock IS 'Part of a stock or a clone of a stock that is used in an experiment';


COMMENT ON COLUMN nd_experiment_stock.stock_id IS 'stock used in the extraction or the corresponding stock for the clone';


CREATE TABLE nd_experiment_protocol (
    nd_experiment_protocol_id serial PRIMARY KEY NOT NULL,
    nd_experiment_id integer NOT NULL references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
    nd_protocol_id integer NOT NULL references nd_protocol (nd_protocol_id) on delete cascade INITIALLY DEFERRED
);

COMMENT ON TABLE nd_experiment_protocol IS 'Linking table: experiments to the protocols they involve.';


CREATE TABLE nd_experiment_phenotype (
    nd_experiment_phenotype_id serial PRIMARY KEY NOT NULL,
    nd_experiment_id integer NOT NULL REFERENCES nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
    phenotype_id integer NOT NULL references phenotype (phenotype_id) on delete cascade INITIALLY DEFERRED,
   constraint nd_experiment_phenotype_c1 unique (nd_experiment_id,phenotype_id)
); 

COMMENT ON TABLE nd_experiment_phenotype IS 'Linking table: experiments to the phenotypes they produce. There is a one-to-one relationship between an experiment and a phenotype since each phenotype record should point to one experiment. Add a new experiment_id for each phenotype record.';

CREATE TABLE nd_experiment_genotype (
    nd_experiment_genotype_id serial PRIMARY KEY NOT NULL,
    nd_experiment_id integer NOT NULL references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
    genotype_id integer NOT NULL references genotype (genotype_id) on delete cascade INITIALLY DEFERRED ,
    constraint nd_experiment_genotype_c1 unique (nd_experiment_id,genotype_id)
);

COMMENT ON TABLE nd_experiment_genotype IS 'Linking table: experiments to the genotypes they produce. There is a one-to-one relationship between an experiment and a genotype since each genotype record should point to one experiment. Add a new experiment_id for each genotype record.';


CREATE TABLE nd_reagent_relationship (
    nd_reagent_relationship_id serial PRIMARY KEY NOT NULL,
    subject_reagent_id integer NOT NULL references nd_reagent (nd_reagent_id) on delete cascade INITIALLY DEFERRED,
    object_reagent_id integer NOT NULL  references nd_reagent (nd_reagent_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL  references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED
);

COMMENT ON TABLE nd_reagent_relationship IS 'Relationships between reagents. Some reagents form a group. i.e., they are used all together or not at all. Examples are adapter/linker/enzyme experiment reagents.';

COMMENT ON COLUMN nd_reagent_relationship.subject_reagent_id IS 'The subject reagent in the relationship. In parent/child terminology, the subject is the child. For example, in "linkerA 3prime-overhang-linker enzymeA" linkerA is the subject, 3prime-overhand-linker is the type, and enzymeA is the object.';

COMMENT ON COLUMN nd_reagent_relationship.object_reagent_id IS 'The object reagent in the relationship. In parent/child terminology, the object is the parent. For example, in "linkerA 3prime-overhang-linker enzymeA" linkerA is the subject, 3prime-overhand-linker is the type, and enzymeA is the object.';

COMMENT ON COLUMN nd_reagent_relationship.type_id IS 'The type (or predicate) of the relationship. For example, in "linkerA 3prime-overhang-linker enzymeA" linkerA is the subject, 3prime-overhand-linker is the type, and enzymeA is the object.';


CREATE TABLE nd_reagentprop (
    nd_reagentprop_id serial PRIMARY KEY NOT NULL,
    nd_reagent_id integer NOT NULL references nd_reagent (nd_reagent_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value character varying(255),
    rank integer DEFAULT 0 NOT NULL,
    constraint nd_reagentprop_c1 unique (nd_reagent_id,type_id,rank)
);

CREATE TABLE nd_experiment_stockprop (
    nd_experiment_stockprop_id serial PRIMARY KEY NOT NULL,
    nd_experiment_stock_id integer NOT NULL references nd_experiment_stock (nd_experiment_stock_id) on delete cascade INITIALLY DEFERRED,
    type_id integer NOT NULL references cvterm (cvterm_id) on delete cascade INITIALLY DEFERRED,
    value character varying(255),
    rank integer DEFAULT 0 NOT NULL,
    constraint nd_experiment_stockprop_c1 unique (nd_experiment_stock_id,type_id,rank)
);

COMMENT ON TABLE nd_experiment_stockprop IS 'Property/value associations for experiment_stocks. This table can store the properties such as treatment';

COMMENT ON COLUMN nd_experiment_stockprop.nd_experiment_stock_id IS 'The experiment_stock to which the property applies.';

COMMENT ON COLUMN nd_experiment_stockprop.type_id IS 'The name of the property as a reference to a controlled vocabulary term.';

COMMENT ON COLUMN nd_experiment_stockprop.value IS 'The value of the property.';

COMMENT ON COLUMN nd_experiment_stockprop.rank IS 'The rank of the property value, if the property has an array of values.';


CREATE TABLE nd_experiment_stock_dbxref (
    nd_experiment_stock_dbxref_id serial PRIMARY KEY NOT NULL,
    nd_experiment_stock_id integer NOT NULL references nd_experiment_stock (nd_experiment_stock_id) on delete cascade INITIALLY DEFERRED,
    dbxref_id integer NOT NULL references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED
);

COMMENT ON TABLE nd_experiment_stock_dbxref IS 'Cross-reference experiment_stock to accessions, images, etc';



CREATE TABLE nd_experiment_dbxref (
    nd_experiment_dbxref_id serial PRIMARY KEY NOT NULL,
    nd_experiment_id integer NOT NULL references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
    dbxref_id integer NOT NULL references dbxref (dbxref_id) on delete cascade INITIALLY DEFERRED
);

COMMENT ON TABLE nd_experiment_dbxref IS 'Cross-reference experiment to accessions, images, etc';


CREATE TABLE nd_experiment_contact (
    nd_experiment_contact_id serial PRIMARY KEY NOT NULL,
    nd_experiment_id integer NOT NULL references nd_experiment (nd_experiment_id) on delete cascade INITIALLY DEFERRED,
    contact_id integer NOT NULL references contact (contact_id) on delete cascade INITIALLY DEFERRED
);
