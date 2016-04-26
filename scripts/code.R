library(logging)
library(extractoR)

datadir <- "/data/rdata"
basicConfig()

options(expressions=20000)

ParseCode(datadir)
ExtractFunctions(datadir)
ExtractFunctionCalls(datadir)

ExtractCodingStyle(datadir)
ResolveFunctionCalls(datadir)
