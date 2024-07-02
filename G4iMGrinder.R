library(G4iMGrinder)
source("parse_args.R")


g4imgrinder <- function() {
  if (!dir.exists("outputs")) {
    dir.create(output_path, recursive = TRUE)
  }
  
  seq_data <- read_sequence()
  seq <- seq_data$seq
  seq_id <- seq_data$seq_id
  
  
  res <- G4iMGrinder(
    Name = seq_id,
    Sequence = seq,
    RunComposition = "C"
  )
  
  result_table <- GiGList.Analysis(GiGList = res, iden = seq_id)
  
  output_csv_path = file.path("outputs", paste0(seq_id, ".csv"))
  write.csv(result_table, file = output_csv_path, row.names = FALSE)
}


read_sequence <- function() {
  if (!is.null(opt$fasta) && file.exists( file.path("example", opt$fasta))) {
    seq_path <- file.path("example", opt$fasta)
    seq <- paste0(
      seqinr::read.fasta(
        file = seq_path,
        as.string = TRUE,
        legacy.mode = TRUE,
        seqonly = TRUE,
        strip.desc = TRUE
      ),
      collapse = ""
    )
    seq_id <- tools::file_path_sans_ext(basename(opt$fasta))
  } else {
    seq <- opt$sequence
    seq_id <- opt$sequence_id
  }
  
  return(list(seq = seq, seq_id = seq_id))
}

if (!interactive()) {
  g4imgrinder()
}