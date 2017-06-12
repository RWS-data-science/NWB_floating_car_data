library(parallel)






no_cores <- detectCores() - 1

cl <- makeCluster(no_cores)






primary <- '192.168.1.235'

machineAddresses <- list(
  list(host=primary,user='johnmount',
       ncore=4),
  list(host='192.168.1.70',user='johnmount',
       ncore=4)
)

spec <- lapply(machineAddresses,
               function(machine) {
                 rep(list(list(host=machine$host,
                               user=machine$user)),
                     machine$ncore)
               })

spec <- unlist(spec,recursive=FALSE)

parallelCluster <- parallel::makeCluster(type='PSOCK',
                                         master=primary,
                                         spec=spec)