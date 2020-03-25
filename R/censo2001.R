#' Download data from 2001 Spanish Census from INE
#' 
#' This function reads the data from 2001 Spanish Census using the information provided by the Spanish Statistical Office (INE).
#' 
#' @param file Character string with the name of the microdata files provided by
#' the INE on the \href{https://www.ine.es/censos2011_datos/cen11_datos_microdatos.htm#}{Census}
#' section. The 2001 files have been separated into 6 different \code{txt} files.
#' \code{file} supports a vector with the path to these 6 files and read them
#' automatically. It allows either a path to the files, 
#' or literal data (single string or raw vector). It also allows compressed
#' files in \code{.gz}, \code{.bz2}, \code{.xz}, or \code{.zip} format.
#' 
#' @return \code{\link[tibble]{tibble}} with all avaliable requested data where each row corresponds to an anonymised citizen.
#' @details This function reads microdata from the 2001 census in Spain. It was originally built using the metadata for 2010 file but it may be used for earlier/later years.
#' 
#' Note that the loaded object will be of considerable size and may require a computer from 8 GB of RAM. In order to avoid this kind of computational issues, you can also download the splitted version provided by the INE.
#' 
#' @author Jorge cimentada adapting the code from Carlos Neira and Carlos J. Gil Bellosta
#' @note The \code{file} parameter allows any flat file with fixed width.
#' @references http://www.ine.es/prodyser/microdatos.htm
#' @examples
#'
#' # First download ftp://www.ine.es/temas/censopv/cen01_ph/parte1.zip
#' # Then ftp://www.ine.es/temas/censopv/cen01_ph/parte2.zip
#' # ...
#' # Until ftp://www.ine.es/temas/censopv/cen01_ph/parte6.zip
#' # Be sure to download from \code{part1} to \code{part6}.
#'
#' # Suppose that the file path to the 6 text files in your local computer are
#' # contained in x. Then:
#' \dontrun{
#' raw <- censo2001(x)
#' summary(raw)
#' }
#' @seealso \code{\link[vroom]{vroom_fwf}} to read fixed width files.
censo2001 <- function(file) {
  read.fwf.microdata(file, 
                     system.file( "metadata", "censo_2001_mdat1.txt", package = "MicroDatosEs" ),
                     ## TODO: I still need to add the variable codings
                     ## I'm lazy since they provide it in word and it's
                     # difficult to parse.
                     ## system.file( "metadata", "censo_2010_mdat2.txt", package = "MicroDatosEs" ),
                     fileEncoding = "UTF-8")
}

