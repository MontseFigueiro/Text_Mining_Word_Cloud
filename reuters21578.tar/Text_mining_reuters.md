TEXT MINING DATA REUTERS
========================

    library(tm)

    ## Loading required package: NLP

    library(wordcloud)

    ## Warning: package 'wordcloud' was built under R version 3.3.1

    ## Loading required package: RColorBrewer

    library(Rcpp)
    library(RColorBrewer)

Corpus Sources and Readers:
---------------------------

    getSources()

    ## [1] "DataframeSource" "DirSource"       "URISource"       "VectorSource"   
    ## [5] "XMLSource"       "ZipSource"

    getReaders()

    ##  [1] "readDOC"                 "readPDF"                
    ##  [3] "readPlain"               "readRCV1"               
    ##  [5] "readRCV1asPlain"         "readReut21578XML"       
    ##  [7] "readReut21578XMLasPlain" "readTabular"            
    ##  [9] "readTagged"              "readXML"

Data reuters
------------

    data("acq")
    acq[[1]]

    ## <<PlainTextDocument>>
    ## Metadata:  15
    ## Content:  chars: 1287

    ruta<- system.file("texts", "acq", package = "tm")
    ruta

    ## [1] "D:/Users/msi/Documents/R/win-library/3.3/tm/texts/acq"

    reuters <- VCorpus(DirSource(ruta),
                       readerControl = list(reader = readReut21578XMLasPlain))

    reuters[[2]]

    ## <<PlainTextDocument>>
    ## Metadata:  16
    ## Content:  chars: 784

    inspect(reuters[1])

    ## <<VCorpus>>
    ## Metadata:  corpus specific: 0, document level (indexed): 0
    ## Content:  documents: 1
    ## 
    ## [[1]]
    ## <<PlainTextDocument>>
    ## Metadata:  16
    ## Content:  chars: 1287

    str(reuters[1])

    ## List of 1
    ##  $ 10:List of 2
    ##   ..$ content: chr "Computer Terminal Systems Inc said\nit has completed the sale of 200,000 shares of its common\nstock, and warrants to acquire a"| __truncated__
    ##   ..$ meta   :List of 16
    ##   .. ..$ author       : chr(0) 
    ##   .. ..$ datetimestamp: POSIXlt[1:1], format: NA
    ##   .. ..$ description  : chr ""
    ##   .. ..$ heading      : chr "COMPUTER TERMINAL SYSTEMS <CPML> COMPLETES SALE"
    ##   .. ..$ id           : chr "10"
    ##   .. ..$ language     : chr "en"
    ##   .. ..$ origin       : chr "Reuters-21578 XML"
    ##   .. ..$ topics       : chr "YES"
    ##   .. ..$ lewissplit   : chr "TRAIN"
    ##   .. ..$ cgisplit     : chr "TRAINING-SET"
    ##   .. ..$ oldid        : chr "5553"
    ##   .. ..$ topics_cat   : chr "acq"
    ##   .. ..$ places       : chr "usa"
    ##   .. ..$ people       : chr(0) 
    ##   .. ..$ orgs         : chr(0) 
    ##   .. ..$ exchanges    : chr(0) 
    ##   .. ..- attr(*, "class")= chr "TextDocumentMeta"
    ##   ..- attr(*, "class")= chr [1:2] "PlainTextDocument" "TextDocument"
    ##  - attr(*, "class")= chr [1:2] "VCorpus" "Corpus"

    reuters[[1]]$content

    ## [1] "Computer Terminal Systems Inc said\nit has completed the sale of 200,000 shares of its common\nstock, and warrants to acquire an additional one mln shares, to\n<Sedio N.V.> of Lugano, Switzerland for 50,000 dlrs.\n    The company said the warrants are exercisable for five\nyears at a purchase price of .125 dlrs per share.\n    Computer Terminal said Sedio also has the right to buy\nadditional shares and increase its total holdings up to 40 pct\nof the Computer Terminal's outstanding common stock under\ncertain circumstances involving change of control at the\ncompany.\n    The company said if the conditions occur the warrants would\nbe exercisable at a price equal to 75 pct of its common stock's\nmarket price at the time, not to exceed 1.50 dlrs per share.\n    Computer Terminal also said it sold the technolgy rights to\nits Dot Matrix impact technology, including any future\nimprovements, to <Woodco Inc> of Houston, Tex. for 200,000\ndlrs. But, it said it would continue to be the exclusive\nworldwide licensee of the technology for Woodco.\n    The company said the moves were part of its reorganization\nplan and would help pay current operation costs and ensure\nproduct delivery.\n    Computer Terminal makes computer generated labels, forms,\ntags and ticket printers and terminals.\n Reuter"

Clean Text
----------

    reuters <- tm_map(reuters, stripWhitespace) # quitar los espacios en blanco que están de más sobre cada comentarios
    reuters <- tm_map(reuters, content_transformer(tolower))#tolower hay que meterla dentro sino no funciona bien
    reuters <- tm_map(reuters, removePunctuation)
    reuters <- tm_map(reuters, removeWords, stopwords("en"))#quitamos palabras stopwords,trae una lista

    reuters[[1]]$content

    ## [1] "computer terminal systems inc said   completed  sale  200000 shares   common stock  warrants  acquire  additional one mln shares  sedio nv  lugano switzerland  50000 dlrs  company said  warrants  exercisable  five years   purchase price  125 dlrs per share computer terminal said sedio also   right  buy additional shares  increase  total holdings   40 pct   computer terminals outstanding common stock  certain circumstances involving change  control   company  company said   conditions occur  warrants   exercisable   price equal  75 pct   common stocks market price   time   exceed 150 dlrs per share computer terminal also said  sold  technolgy rights   dot matrix impact technology including  future improvements  woodco inc  houston tex  200000 dlrs   said   continue    exclusive worldwide licensee   technology  woodco  company said  moves  part   reorganization plan   help pay current operation costs  ensure product delivery computer terminal makes computer generated labels forms tags  ticket printers  terminals reuter"

    class(reuters)

    ## [1] "VCorpus" "Corpus"

    library(SnowballC)

SnowballC
---------

    Snowreuters <- tm_map(reuters[1:10], stemDocument)

    Snowreuters[[1]]$content

    ## [1] "comput termin system inc said   complet  sale  200000 share   common stock  warrant  acquir  addit one mln share  sedio nv  lugano switzerland  50000 dlrs  compani said  warrant  exercis  five year   purchas price  125 dlrs per share comput termin said sedio also   right  buy addit share  increas  total hold   40 pct   comput termin outstand common stock  certain circumst involv chang  control   compani  compani said   condit occur  warrant   exercis   price equal  75 pct   common stock market price   time   exceed 150 dlrs per share comput termin also said  sold  technolgi right   dot matrix impact technolog includ  futur improv  woodco inc  houston tex  200000 dlrs   said   continu    exclus worldwid license   technolog  woodco  compani said  move  part   reorgan plan   help pay current oper cost  ensur product deliveri comput termin make comput generat label form tag  ticket printer  termin reuter"

WordCloud reuters
-----------------

    wordcloud(reuters,scale=c(5,0.5),max.words=100,random.order=FALSE,rot.per=0.35,use.r.layout=FALSE,
              colors=brewer.pal(8, "Dark2"))

![](https://github.com/MontseFigueiro/Text_Mining_Word_Cloud/blob/master/reuters21578.tar/Text_mining_reuters_files/figure-markdown_strict/unnamed-chunk-7-1.png)

    wordcloud(Snowreuters,scale=c(5,0.5),max.words=100,random.order=FALSE,rot.per=0.35,use.r.layout=FALSE,
              colors=brewer.pal(8, "Dark2"))

![](https://github.com/MontseFigueiro/Text_Mining_Word_Cloud/blob/master/reuters21578.tar/Text_mining_reuters_files/figure-markdown_strict/unnamed-chunk-7-2.png)
\#\#word matrix

    matrix <- DocumentTermMatrix(reuters) #matriz original de frecuencias
    findFreqTerms(matrix, 100)#aparecen mas de 100 veces

    ## [1] "dlrs" "said"

    findFreqTerms(matrix,50)#aparecen más de 50 veces

    ## [1] "company" "dlrs"    "inc"     "mln"     "pct"     "reuter"  "said"   
    ## [8] "shares"

    freq.term <- findFreqTerms(matrix,lowfreq = 15)
    freq.term

    ##  [1] "1986"       "acquire"    "agreed"     "also"       "american"  
    ##  [6] "analysts"   "bank"       "business"   "cash"       "common"    
    ## [11] "company"    "corp"       "dlrs"       "express"    "group"     
    ## [16] "inc"        "management" "market"     "mln"        "new"       
    ## [21] "offer"      "one"        "pct"        "reuter"     "rmj"       
    ## [26] "said"       "securities" "share"      "shares"     "shearson"  
    ## [31] "stake"      "stock"      "value"      "viacom"     "will"

    matrixreuters <- as.matrix(matrix)
    frequency <- colSums(matrixreuters)
    frequency <- sort(frequency, decreasing=TRUE)
    head(frequency,10)

    ##    said    dlrs     pct     mln company     inc  shares  reuter   stock 
    ##     186     100      70      65      63      53      52      50      46 
    ##    will 
    ##      35

Remove Sparse Terms
-------------------

    matrixreuters2<- removeSparseTerms(matrix, sparse = 0.95)
    m2 <- as.matrix(matrixreuters2)
    distMatrix <- dist(scale(m2))
    fit <- hclust(distMatrix, method = "ward.D")
    plot(fit)
    rect.hclust(fit, k = 6) # cut tree into 6 clusters 

![](https://github.com/MontseFigueiro/Text_Mining_Word_Cloud/blob/master/reuters21578.tar/Text_mining_reuters_files/figure-markdown_strict/unnamed-chunk-10-1.png)

    frequency2 <- colSums(m2)
    frequency2 <- sort(frequency2, decreasing=TRUE)
    head(frequency2,10)

    ##    said    dlrs     pct     mln company     inc  shares  reuter   stock 
    ##     186     100      70      65      63      53      52      50      46 
    ##    will 
    ##      35

    inspect(matrixreuters2[1:10,1:10])

    ## <<DocumentTermMatrix (documents: 10, terms: 10)>>
    ## Non-/sparse entries: 11/89
    ## Sparsity           : 89%
    ## Maximal term length: 12
    ## Weighting          : term frequency (tf)
    ## 
    ##      Terms
    ## Docs  125 1985 1986 1987 200 acquire acquired acquisition acquisitions
    ##   10    1    0    0    0   0       1        0           0            0
    ##   12    0    0    1    0   0       0        0           0            3
    ##   44    0    0    0    0   0       0        0           0            0
    ##   45    0    0    1    0   0       0        1           0            0
    ##   68    0    0    0    0   0       0        1           0            0
    ##   96    0    0    0    0   0       0        0           0            0
    ##   110   0    1    0    0   1       0        0           0            1
    ##   125   0    0    0    0   0       0        0           0            0
    ##   128   0    0    0    0   0       0        0           0            0
    ##   134   0    0    0    0   0       0        0           0            0
    ##      Terms
    ## Docs  added
    ##   10      0
    ##   12      0
    ##   44      0
    ##   45      0
    ##   68      0
    ##   96      0
    ##   110     1
    ##   125     0
    ##   128     0
    ##   134     0

TP-IDF
------

Normaliza le quita importancia a las palabras que aparecen repetidas en
muchos documentos.

    reuters.norm <- weightTfIdf(matrix)
    inspect(reuters.norm[1:10,1:10])

    ## <<DocumentTermMatrix (documents: 10, terms: 10)>>
    ## Non-/sparse entries: 2/98
    ## Sparsity           : 98%
    ## Maximal term length: 6
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)
    ## 
    ##      Terms
    ## Docs  05165 0523       100 10000 100000        101 105 1078 110 1100
    ##   10      0    0 0.0000000     0      0 0.00000000   0    0   0    0
    ##   12      0    0 0.0000000     0      0 0.00000000   0    0   0    0
    ##   44      0    0 0.0000000     0      0 0.00000000   0    0   0    0
    ##   45      0    0 0.0000000     0      0 0.02577103   0    0   0    0
    ##   68      0    0 0.0000000     0      0 0.00000000   0    0   0    0
    ##   96      0    0 0.1132648     0      0 0.00000000   0    0   0    0
    ##   110     0    0 0.0000000     0      0 0.00000000   0    0   0    0
    ##   125     0    0 0.0000000     0      0 0.00000000   0    0   0    0
    ##   128     0    0 0.0000000     0      0 0.00000000   0    0   0    0
    ##   134     0    0 0.0000000     0      0 0.00000000   0    0   0    0

    reuters.norm.matrix <- as.matrix(reuters.norm)
    frequency.norm <- colSums(reuters.norm.matrix)
    frequency.norm <- sort(frequency.norm, decreasing=TRUE)
    head(frequency.norm)

    ##    shares   liebert      dlrs       rmj      corp       mln 
    ## 0.7854376 0.7054820 0.6901116 0.6870388 0.6542134 0.6469322
