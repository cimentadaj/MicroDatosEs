% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/censo1991.R
\name{censo1991}
\alias{censo1991}
\alias{censo1991_provincias}
\title{Download data from 1991 Spanish Census from INE}
\usage{
censo1991(file)

censo1991_provincias(file)
}
\arguments{
\item{file}{Character string with the name of the microdata files provided by
the INE on the \href{https://www.ine.es/censos2011_datos/cen11_datos_microdatos.htm#}{Census}
section. For the complete data, the path to the \code{txt} file is enough.

Alternatively, for \code{censo1991_provincias}, \code{file} needs to be
a vector with the path to the 52 province files.

For both cases, it allows either a path to the files, or literal data
(single string or raw vector). It also allows compressed files in
\code{.gz}, \code{.bz2}, \code{.xz}, or \code{.zip} format.}
}
\value{
\code{\link[tibble]{tibble}} with all avaliable requested data where
each row corresponds to an anonymised citizen.
}
\description{
This function reads the data from 1991 Spanish Census using the information
provided by the Spanish Statistical Office (INE).
}
\details{
This function reads microdata from the 1991 census in Spain. It was
originally built using the metadata for 2010 file but it may be used for
earlier/later years.

Note that the loaded object will be of considerable size and may require a
computer from 8 GB of RAM. In order to avoid this kind of computational
issues, you can also download the splitted version provided by the INE.
}
\note{
The \code{file} parameter allows any flat file with fixed width.
}
\examples{

# First download ftp://www.ine.es/temas/censopv/cen91_p/cen91_per_2.zip
# Suppose that the file path to the zip file in your local computer is
# contained in x. Then:

\dontrun{
raw <- censo1991(x)
summary(raw)
}


# Downloading the province data is also possible

\dontrun{
prov_paths <-
  paste0("ftp://www.ine.es/temas/censopv/cen91_p/p",
         formatC(1:52, width = "2", flag = "0"),
         "mper_cen91.zip")

for (i in prov_paths) {
  dir_save <- paste0("./", basename(i))
  download.file(i, dir_save)
}

all_paths <- list.files(".",
                        pattern = paste0(basename(prov_paths), collapse = "|"),
                        full.names = TRUE)

raw <- censo1991_provincias(all_paths)
summary(raw)
}

}
\references{
http://www.ine.es/prodyser/microdatos.htm
}
\seealso{
\code{\link[vroom]{vroom_fwf}} to read fixed width files.
}
\author{
Jorge cimentada adapting the code from Carlos Neira and Carlos J. Gil Bellosta
}
