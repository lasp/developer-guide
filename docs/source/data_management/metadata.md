# Metadata

## Purpose

Metadata supports data science workflows by:

- Ensuring datasets are discoverable and usable by both humans and machines.
- Meeting internal and external policies for data accessibility and preservation.
- Enhancing collaboration by providing clear and standardized metadata practices.
- Contributing to the overall success of projects by enabling proper data usage and interoperability.

## What is Metadata

A dataset generally consists of sets of measured or modeled values. However, the values alone are
insufficient to understand and use that dataset. Consider this example of a very small dataset:

**Temperature: 31.5**

The data point “Temperature: 31.5” raises many questions:

- Temperature of what?
- According to whom or what?
- Collected when/where?
- Measured or calculated?
- If calculated, how?
- What units?
- To what precision?

To make this dataset FAIR (Findable, Accessible, Interoperable, and Reusable), additional information is needed.

Metadata is information (data) about a dataset. It includes:

- Time and spatial coverages and cadences
- Units
- Processing level
- Data quality
- Instrument details
- Principal Investigator
- Provenance
- Special alerts, etc.

Ideally, metadata provides all the information necessary to find, understand,
and use the dataset correctly. Good quality metadata is critical for data to be FAIR.

## Benefits of Good Quality Metadata

Good quality, searchable metadata enables people to find data that fits their needs:

- **Good quality**: Sufficient information is provided.
- **Searchable**: Users can find data by various facets like spatial or temporal coverage.

## Metadata Storage, Formats, and Access

### Storage Options

The best practices for metadata storage include:

1. **Machine-readable metadata** consumable by common tools
2. **Publicly accessible metadata** readable by humans.
3. **Avoid private, inaccessible formats** like personal notebooks or sticky notes.

#### Examples of Metadata Storage

- **Prose embedded in HTML**: Readable by humans but not easily consumable by tools.
- **Public spreadsheets**: Readable by tools that understand the structure but not widely accessible otherwise.
- **Self-describing formats**: Examples include:
  - **NetCDF, HDF, FITS**: Include specific metadata properties like variables, geospatial coverage, and time coverage.
  - **Header information** in CSV or ASCII tables:
    - Simple but less machine-readable.

Machine readability often depends on established metadata conventions, such as
**Climate and Forecast (CF) conventions** used widely in atmospheric science ([More details here](https://www.unidata.ucar.edu/software/netcdf/workshops/most-recent/cf/index.html)).

### LASP Metadata Repository

LASP is developing the **LASP Extended Metadata Repository (LEMR)** to store and access dataset metadata:

- Automates and dynamically accesses essential properties for data services.
- Plans to extend metadata management capabilities for LASP scientists.

## Metadata Formats

Metadata formats refer to schemas describing the metadata structure. Examples include:

- **[ISO 19115](https://www.fgdc.gov/metadata/iso-standards)**: Geographic information and services.
- **[SPASE](https://spdf.gsfc.nasa.gov/spdf-documents/SPASE_and_SPDF.html)**: Used in Heliophysics.

At LASP, the **laspds schema** is used for applications serving data, with plans to
integrate with standard schemas like SPASE and ISO 19115.

## What Metadata to Save

### Key Considerations

At project inception:

- Identify essential metadata for understanding and using the dataset.
- Create a plan to preserve this information.

### Balancing Minimal and Comprehensive Metadata

Repositories often balance between minimal metadata (to lower barriers for participation)
and sufficient metadata for full dataset understanding. Repositories recognize that providing
quality metadata takes resources.

- Example: **CU Scholar** requires:
  - Landing page URL
  - Names of dataset creators
  - Title
  - Publishing organization
  - Resource type

This information alone would not be sufficient to use a dataset, but it is sufficient
to allow CU Scholar to serve the dataset. CU Scholar expects additional details
(e.g., coverages, units, quality indicators) to be available on the landing page or
via self-describing formats.

## Provenance

The **provenance** of a dataset describes its history and is critical for using datasets correctly:

- Origin of the data
- Processing methods
- Calibration and validation details
- Software versions used

Data producers should record:

- Dataset inputs
- Processing steps
- Configuration, calibration, and validation details

Provenance is often provided as descriptive prose, making machine-readable text a reasonable option.

**Learn More**: [The Importance of Data Set Provenance for Science](https://eos.org/opinions/the-importance-of-data-set-provenance-for-science).

## Summary of Metadata Workflow

1. **Identify Necessary Metadata**:
  - At project inception, determine what metadata is essential for understanding and using the dataset.
2. **Choose the Appropriate Storage Option**:
  - Use machine-readable formats like NetCDF or HDF where possible.
  - For simpler use cases, include metadata in file headers or spreadsheets, ensuring structure is clear.
3. **Follow Metadata Conventions**:
  - Adhere to standards for machine-readability.
  - Consult metadata experts when encoding complex datasets.
4. **Leverage LASP’s Tools**:
  - Use the **LASP Extended Metadata Repository (LEMR)** for automated and dynamic metadata management if applicable.
  - Work with LASP administrators to input metadata into LEMR.
5. **Maintain Provenance**:
  - Record dataset inputs, processing, calibration, and validation details.
  - Provide descriptive prose or structured metadata to ensure provenance is clear and traceable.

## Useful Links

- [CF Conventions for NetCDF](https://www.unidata.ucar.edu/software/netcdf/workshops/most-recent/cf/index.html)
- [The Importance of Dataset Provenance for Science](https://eos.org/opinions/the-importance-of-data-set-provenance-for-science)
- [NASA DOI Landing Page Requirements](https://wiki.earthdata.nasa.gov/display/DOIsforEOSDIS/DOI+Landing+Page)
- [CU Scholar Metadata Requirements](https://scholar.colorado.edu/faq)

## Acronyms

- **CF** = Climate and Forecast
- **FAIR** = Findable, Accessible, Interoperable, and Reusable
- **ISO** = International Organization for Standardization
- **LEMR** = LASP Extended Metadata Repository
- **SPASE** = Space Physics Archive Search and Extract

Credit: Content taken from a Confluence guide written by Anne Wilson and Shawn Polson.
