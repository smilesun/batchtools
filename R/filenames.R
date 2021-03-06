dir = function(reg, what) {
  fs::path(fs::path_expand(reg$file.dir), what)
}

getResultFiles = function(reg, ids) {
  fs::path(dir(reg, "results"), sprintf("%i.rds", if (is.atomic(ids)) ids else ids$job.id))
}

getLogFiles = function(reg, ids) {
  job.hash = log.file = NULL
  tab = reg$status[list(ids), c("job.id", "job.hash", "log.file")]
  tab[is.na(log.file) & !is.na(job.hash), log.file := sprintf("%s.log", job.hash)]
  tab[!is.na(log.file), log.file := fs::path(dir(reg, "logs"), log.file)]$log.file
}

getJobFiles = function(reg, hash) {
  fs::path(reg$file.dir, "jobs", sprintf("%s.rds", hash))
}

getExternalDirs = function(reg, ids) {
  fs::path(dir(reg, "external"), if (is.atomic(ids)) ids else ids$job.id)
}

mangle = function(x) {
  sprintf("%s.rds", base32_encode(x, use.padding = FALSE))
}

unmangle = function(x) {
  base32_decode(stri_sub(x, to = -5L), use.padding = FALSE)
}
