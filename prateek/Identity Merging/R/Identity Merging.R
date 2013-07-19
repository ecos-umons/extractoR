start<-function()
{
  library(RODBC)
  library(combinat)
  library(RecordLinkage)
 data<-getdata()
  merge(data)
}
intdb<-function()
{
  channel<-odbcConnect('r',uid="root",pwd="root")
  sqlQuery(channel,"use finaldb;")
  return(channel)
}
closedb<-function()
{
  odbcCloseAll()
}
getdata<-function()
{
  channel<-intdb()
  data<-sqlFetch(channel,'persons',rownames=F,colnames=F)
  closedb()
  return(data)
}
dbwrite<-function(aid1,aid2)
{
  channel<-intdb()
  dma<-sqlFetch(channel,'mergedauthors',colnames=F,rownames=F)
  dmid<-sqlFetch(channel,'mergedid',colnames=F,rownames=F)[,1]
  mids<-dma[,1]
  mid<-c(1)
  aids<-dma[,2]
  #print((dmid+2))
  if(length(aids)>0)
  {
    test1<-match(aid1,aids,nomatch=-1)
    test2<-match(aid2,aids,nomatch=-1)
   #if match is found i.e. one of the id is already merged with someother id
    if(test1!=-1 || test2!=-1)
    {
      #print("here")
      tempmid1<-NULL
      tempmid2<-NULL
      # getting the earlier merged id of the table
      if(test1!=-1)
      {
        tempmid1<-mids[test1]
      }
     if(test2!=-1)
      {
        tempmid2<-mids[test2]
      }
      # if one of them is not merged but other is merged. Using length instead of values due to failure of if else to evaluate NULL values.
      if(length(tempmid1)!=0 && length(tempmid2)==0 )
      {
        #print("having fun here")
        mid<-tempmid1
        dfma2<-data.frame(mid,aid2)
        names(dfma2)<-c("mergeid","aid")
        try(sqlSave(channel,dfma2,tablename='mergedauthors',append=T,rownames=F,colnames=F))
      }
      # if one of them is not merged but other is merged
      if(length(tempmid2)!=0 && length(tempmid1)==0)
      {
      #  print("i am here")
        mid<-tempmid2
        dfma<-data.frame(mid,aid1)
        names(dfma)<-c("mergeid","aid")
        try(sqlSave(channel,dfma,tablename='mergedauthors',append=T,rownames=F,colnames=F))
      }
      #if both are merged
      if(length(tempmid1)!=0 && length(tempmid2)!=0)
      {
        # if both are same then do nothing
        if(tempmid1==tempmid2)
        {
          #print("here")
        }
        # Here we can either update mergedid of either tempmid1 or tempid2. I am selecting tempmid1. 
        else
        {
          #print("yaha hu")
          tdta<-sqlFetch(channel,'mergedauthors',colnames=F,rownames=F)
          tdta[,1][grep(tempmid1,tdta[,1])]<-tempmid2 # assigning tempmid2 to all the tempmid1
          sqlUpdate(channel,tdta,tablename='mergedauthors',index='aid')
        }
      }
      
    }
    # if no match is found i.e neither of them has been previously merged
    else
    {
      #print("here")
      tempmid1<-(max(mids)+1)
      mid<-tempmid1
      dfma<-data.frame(mid,aid1)
      dfma2<-data.frame(mid,aid2)
      dfmid<-data.frame(mid)
      names(dfmid)<-c("idmergedid")
      names(dfma)<-c("mergeid","aid")
      names(dfma2)<-c("mergeid","aid")
      try(sqlSave(channel,dfmid,tablename='mergedid',append=T,rownames=F,colnames=F))
      try(sqlSave(channel,dfma,tablename='mergedauthors',append=T,rownames=F,colnames=F))
      try(sqlSave(channel,dfma2,tablename='mergedauthors',append=T,rownames=F,colnames=F))
    }
    #print(test1)
    #print(test2)
  }
  # if no previous entries are in the table
  else{
   # print("here")
    if(length(dmid)>0)
    {
      mid<-(max(dmid)+1)
    }
    dfma<-data.frame(mid,aid1)
    dfma2<-data.frame(mid,aid2)
    dfmid<-data.frame(mid)
    names(dfmid)<-c("idmergedid")
    names(dfma)<-c("mergeid","aid")
    names(dfma2)<-c("mergeid","aid")
    try(sqlSave(channel,dfmid,tablename='mergedid',append=T,rownames=F,colnames=F))
    try(sqlSave(channel,dfma,tablename='mergedauthors',append=T,rownames=F,colnames=F,fast=F))
    try(sqlSave(channel,dfma2,tablename='mergedauthors',append=T,rownames=F,colnames=F,fast=F))
  }
  closedb()
}
gpe<-function(author)
{
  list<-permn(author)
  posid<-NULL
  if(length(list)>0)
  {
    for(t in (1:length(list)))
    {
      posid<-c(posid,paste(list[[t]],collapse="."))
      posid<-c(posid,paste(list[[t]],collapse=" "))
      posid<-c(posid,paste(list[[t]],collapse="+"))
      posid<-c(posid,paste(list[[t]],collapse="-"))
      posid<-c(posid,paste(list[[t]],collapse="_"))
    }
  }
  return(posid)
}
neperfect<-function(email,posid)
{
  #print("here")
  normail<-email
  if(length(normail)>0)
  {#print(posid)
    #print(normail[i])
    for(i in (1:length(normail)))
    {
      #print(normail[i])
      #print(email[i])
      # print(tposid)
      # tposid<-NULL
      #print(posid)
      test<-(setdiff(normail[i],setdiff(normail[i],posid)))
      # print(posid)
      
      # print(normail[i])
      
      if(length(test)>0)
      {
       return(TRUE)
      }
      else
      {
        return(FALSE)
      }
    }
  }
  
}
neapprox<-function(email,name)
{
  # print("in nmapprox")
  temail<-email
  lst<-NULL
  #print(temail)
  for(t in temail)
  {
    temp<-unlist(strsplit(t,"@"))[1]
    temp2<-unlist(strsplit(temp,"<|!|>|[|]|$|%|&|(|\\^|\\+|\\-|)|,|\\.| "))
    temp2<-gsub("<|!|>|[|]|$|%|&|(|\\^|\\+|\\-|)|,|\\.| ","",temp2)
    lst<-permn(temp2)
  # print(length(list))
    #print(temp2)
    output<-F
    if(length(lst)>0)
    {
      #z<-length(lst)
      #print("here")
      for(t in (1:length(lst)))
      {
        
        #print("in loop")
       # print(lst)
       p<-lst[[t]]
        comparator<-(paste(p,collapse=" "))
       #print(comparator)
       # print(name)
        sim<-levenshteinSim(name,comparator)
      # print(sim)
        
        #print(email)
        # print(t)
        # print(email)
        # print(aut)
        if(sim>.7)   ####### threshold if crossed
        {
         output<-T
        }
      }
    }
    return(output)
  }
}
