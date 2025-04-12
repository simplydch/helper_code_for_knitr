### Code goes through a sweave (.rnw) file and looks for all chunks, it then loads,
### in order, each cache chunk.  This is useful if you want to troubleshoot code in
### the document that isn't working without re-running all code chunks.

# Set the path to your original knitr file and cache directory
original_file <- "path/to/file.rnw"  # Replace with your actual Rmd or R script file
cache_dir <- "path/to/cache_dir/"    # Replace with your actual cache directory

# Function to extract chunk names from the original file
extract_chunk_names <- function(file) {
  lines <- readLines(file)
  # Match lines that define R chunks
  chunk_names <- grep("^\\s*<<([^>]+)>>=", lines, value = TRUE)
  # Extract the chunk name
  chunk_names <- sub("(^\\s*<<)([^,]+)(.*)(>>=.*)", "\\2", chunk_names)  
  return(chunk_names)
}

# Get the chunk names from the original file
chunk_names <- extract_chunk_names(original_file)

# Load cached files in the order of chunk names
for (chunk_name in chunk_names) {
  # Construct the expected cached file name
  matching_files <- list.files(cache_dir, pattern = paste0(chunk_name, "_[0-9a-z]+" , "\\.RData"), full.names = TRUE)
  
  tryCatch({
    if (length(matching_files)>0) {
      knitr::load_cache(chunk_name, path=cache_dir)
      message(paste("Loaded:", chunk_name))
    } else {
      message(paste("Cached file not found for chunk:", chunk_name))
    }
  }, error = function(e) {
    # Handle the error
    cat(paste("Error - Cached file not loaded:", chunk_name,"\n"))
  })
}



