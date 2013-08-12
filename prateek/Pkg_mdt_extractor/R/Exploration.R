pkgexplore<-function(path){
  files<-dir(path,recursive=F,full.names=TRUE)
  dindex<-grep("DESCRIPTION",files)
  namespace<-files[grep("NAMESPACE",files)]
  nmsexplore(namespace)
  if(length(dindex)>1) desexplore(files[dindex[2]]) else if(length(dindex)==1) desexplore(files[dindex[1]])
  rfiles<-dir(path,pattern="^R$",recursive=F)
  rpath<-(file.path(path,(setdiff(rfiles,setdiff(rfiles,c('R'))))))# To find the r source directory
  if(length(rpath)>1 && length(dindex)>1 ){ srcexplore(rpath[2],files[dindex[2]],namespace)}
else if(length(rpath)==1 && length(dindex)>1){ srcexplore(rpath[1],files[dindex[2]],namespace)}
  else if(length(rpath)>1 && length(dindex)==1){ srcexplore(rpath[2],files[dindex[1]],namespace)}
  else if(length(rpath)==1 && length(dindex)==1){ srcexplore(rpath[1],files[dindex[1]],namespace)}
  #rpath<-path
} 

desexplore <- function(dpath){
 #print(dpath,rpath)
  #print(dpath)
    #print(readLines(dpath))
      fvector<-finalvector(dpath)
     # print(fvector)
     dframepkgname(fvector)
      dframepackage(fvector)
      #print(dependency(fvector))
     
   
      
 }
nmsexplore<-function(namespace)
{
  #nmsres(namespace)
}
# Adds each identified elements of the description in the vector
finalvector<-function(despath)
{
  dpath<-despath
  fvector<-NULL #for separating each specific fields of the description file and storing it in a separate index
  temp <- (grep("Package:|Priority:|Version:|Date:|Title:|Author:|Maintainer:|Depends:|Description:|License:|URL:|Packaged:|Authors@R:|Encoding:|Copyright:|SystemRequirements:|Imports:|Suggests:|Enhances:|Revision:|BugReports:|biocViews:|BundleDescription:|Collate\\.unix:|Collate\\.windows:|Collate:|KeepSource:|LazyData:|LazyLoad:|ByteCompile:|ZipData:|Biarch:|BuildVignettes:|VignetteBuilder:|NeedsCompilation:|OS_type:|Classification\\/ACM:|Classification\\/JEL:|Classification\\/MSC:|Language:|Built:|Note:|Contact:|MailingList:|Repository:|Date\\/Publication:|Architecture:|Archs:|Requires:|Contains:|Type:",readLines(dpath)))  
  if(length(temp)>=1)
  {
    if(length(temp>1))
    {      for(i in 1:(length(temp)-1))
    {
      fvector<-c(fvector,(paste(readLines(dpath)[temp[i]:((temp[i+1])-1)],collapse="")))   #for collating description        
    }
    }
    #for collating last line of the description
    fvector<-c(fvector,(paste(readLines(dpath)[temp[length(temp)]:length(readLines(dpath))],collapse="")))}
    
}
