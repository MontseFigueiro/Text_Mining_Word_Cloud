#TEXT MINING DATA REUTERS
```{r}
library(tm)
library(wordcloud)
library(Rcpp)
library(RColorBrewer)
```
##Corpus Sources and Readers:
```{r}  
getSources()
getReaders()
```
##Data reuters
```{r}
data("acq")
acq[[1]]
ruta<- system.file("texts", "acq", package = "tm")
ruta
reuters <- VCorpus(DirSource(ruta),
                   readerControl = list(reader = readReut21578XMLasPlain))

reuters[[2]]

inspect(reuters[1])
str(reuters[1])
reuters[[1]]$content
```
##Clean Text
```{r}
reuters <- tm_map(reuters, stripWhitespace) # quitar los espacios en blanco que están de más sobre cada comentarios
reuters <- tm_map(reuters, content_transformer(tolower))#tolower hay que meterla dentro sino no funciona bien
reuters <- tm_map(reuters, removePunctuation)
reuters <- tm_map(reuters, removeWords, stopwords("en"))#quitamos palabras stopwords,trae una lista

reuters[[1]]$content
class(reuters)
``` 
```{r}
library(SnowballC)
```
##SnowballC 
```{r}
Snowreuters <- tm_map(reuters[1:10], stemDocument)

Snowreuters[[1]]$content
```
##WordCloud reuters
```{r}
wordcloud(reuters,scale=c(5,0.5),max.words=100,random.order=FALSE,rot.per=0.35,use.r.layout=FALSE,
          colors="2")
wordcloud(Snowreuters,scale=c(5,0.5),max.words=100,random.order=FALSE,rot.per=0.35,use.r.layout=FALSE,
          colors="2")
```
##word matrix
```{r}
matrix <- DocumentTermMatrix(reuters) #matriz original de frecuencias
findFreqTerms(matrix, 100)#aparecen mas de 100 veces
findFreqTerms(matrix,50)#aparecen más de 50 veces
freq.term <- findFreqTerms(matrix,lowfreq = 15)
freq.term
```{r}
matrixreuters <- as.matrix(matrix)
frequency <- colSums(matrixreuters)
frequency <- sort(frequency, decreasing=TRUE)
head(frequency,10)
```
##Remove Sparse Terms
```{r}
matrixreuters2<- removeSparseTerms(matrix, sparse = 0.95)
m2 <- as.matrix(matrixreuters2)
distMatrix <- dist(scale(m2))
fit <- hclust(distMatrix, method = "ward.D")
plot(fit)
rect.hclust(fit, k = 6) # cut tree into 6 clusters 

frequency2 <- colSums(m2)
frequency2 <- sort(frequency2, decreasing=TRUE)
head(frequency2,10)

inspect(matrixreuters2[1:10,1:10])
```
##TP-IDF

#Normaliza le quita importancia a las palabras que aparecen repetidas en muchos documentos.

```{r}
reuters.norm <- weightTfIdf(matrix)
inspect(reuters.norm[1:10,1:10])
reuters.norm.matrix <- as.matrix(reuters.norm)
frequency.norm <- colSums(reuters.norm.matrix)
frequency.norm <- sort(frequency.norm, decreasing=TRUE)
head(frequency.norm)
```


