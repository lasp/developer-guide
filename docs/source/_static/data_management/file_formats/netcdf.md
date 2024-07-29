# NetCDF
>**Warning**
> This guide needs additional information

NetCDF (Network Common Data Form), is a file format that stores scientific data in arrays. Array values may be accessed
directly, without knowing how the data are stored, and metadata information may be stored with the data.

* Binary file format commonly used for scientific data
* Self-describing, includes metadata
* Multi-dimensional array data model

The [netCDF data model](https://docs.unidata.ucar.edu/netcdf-c/current/netcdf_data_model.html) consists of the following:
* variable
  * Multi-dimensional array
  * Column-oriented: each variable as a separate entity
* dimension
  * Usually temporal, spatial, spectral, ...
  * Can be unlimited length. One, at most, is recommended for a growing time dimension
* attribute
  * Metadata: global and variable level
* group
  * Akin to directories
  * Avoid unless you really need the complex structure


## Purpose for this guideline
NetCDF is a file format commonly used at LASP...

Benefits of using netCDF:
* Self-describing
  * structure captures coordinate system (functional relationship)
  * includes metadata
* Efficient storage
  * packing
  * compression
* Efficient access
  * chunking
  * http byte range
  * parallel IO
* Open specification (unlike IDL save files)

## Options for this guideline
There are two netCDF data models:
* NetCDF-3 classic
* NetCDF-4 built on HDF5
  * recommended but prefer classic constructs

## How to apply this guideline

#### NetCDF Files
* Binary format with open specification
* Requires software libraries to read and write C, Fortran, Java, python, IDL, ...
* Internal compression, don't bother to compress NetCDF files externally
* HTTP byte range requests
* Parallel IO
* nc file extension
* Don't be afraid of big files

#### Coordinate System
* Dimensions should be used to define a coordinate system
  * e.g. temporal, spatial, spectral
  * Avoid using dimensions to group data
  * Think "functional relationship". Each independent variable should represent a dimension.
* coordinate variable
  * 1D variable with dimension of the same name
  * strictly monotonic (ordered)
  * no missing values
  * Independent variable of functional relationship
  * Every dimension should have one
* shared dimensions
  * Each variable should reuse dimensions to indicate that they share the same coordinates (domain set)

#### Time as Coordinate Variable
* If the data are a function of a single time dimension then there should be a single time variable
  * avoid breaking time up by date and time of day
* Prefer numeric time units
  * time unit since an epoch
  * e.g. "seconds since 1970-01-01", "microseconds since 1980-01-06"

#### Metadata
* Optional but useful to make NetCDF file self-describing
* attribute
  * global (dataset level)
    * title
    * history (provenance)
  * variable
    * long_name
    * units
* Conventions
  * [Climate and Forecast (CF)](https://cfconventions.org/Data/cf-conventions/cf-conventions-1.8/cf-conventions.html)
  * [Attribute Convention for Data Discovery (ACDD)](https://wiki.esipfed.org/Attribute_Convention_for_Data_Discovery_1-3)
  * [udunits](https://www.unidata.ucar.edu/software/udunits/): standard units

#### Other useful variable attributes
* missing_value
  * prefer over _FillValue
  * NaN is a good option
* valid_range, valid_min, valid_max
* scale_factor, add_offset (packed values)
* [cell_methods](https://cfconventions.org/Data/cf-conventions/cf-conventions-1.8/cf-conventions.html#_data_representative_of_cells): standards for representing data cells (bins)
  * e.g. daily average, wavelength bins

## Useful Links
* [NetCDF User's Guide](https://docs.unidata.ucar.edu/nug/current/)
* [NetCDF ToolsUI](https://docs.unidata.ucar.edu/netcdf-java/current/userguide/toolsui_ref.html)


Credit: Content taken from a Confluence guide written by Doug Lindholm