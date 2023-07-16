# Automação de Web Scraping em R: Coletando Dados Salariais do Departamento de Segurança Pública do Texas

O código que estamos discutindo é um script de web scraping em R que tem como objetivo extrair dados de salários do Departamento de Segurança Pública do Texas. O código utiliza bibliotecas como tidyverse, RSelenium, rvest e data.table para realizar a raspagem de dados de uma página web.
 A primeira etapa consiste na importação das bibliotecas necessárias para o projeto. Em seguida, é definida a URL do site que será acessado para a raspagem dos dados.
 O servidor RSelenium é configurado e um cliente RSelenium é criado para interagir com o navegador. Através do cliente, o script navega até a URL definida anteriormente.
 A coleta de dados é realizada em um loop, percorrendo cada página da tabela de salários. O código extrai os dados da tabela de cada página e os armazena em um data frame. Caso haja mais páginas, o script clica no botão "Próxima página" e continua a coleta de dados. Esse processo é repetido até que todas as páginas sejam percorridas.
 Após a coleta de dados, é feita a limpeza dos mesmos. O código renomeia a terceira coluna para "Agency" e remove o símbolo de dólar e substitui as vírgulas por pontos na coluna "Annual salary".
 Por fim, os dados são salvos em um arquivo CSV e o cliente e servidor RSelenium são fechados.
 Esse código é útil para extrair informações de salários do Departamento de Segurança Pública do Texas de forma automatizada, permitindo a análise e manipulação dos dados coletados.
![tabela](https://github.com/EdsonLuizSilva/WebScraping-em-R/assets/65295796/0bd734d7-8969-4ff6-a95a-890e85a850b0)

Vou explicar cada passo do código fornecendo um trecho de código correspondente a cada etapa:
 1. Importação das bibliotecas:
```
library(tidyverse)
library(RSelenium)
library(rvest)
library(data.table)
```

Nesta etapa, as bibliotecas necessárias são importadas para o ambiente de trabalho do R.

 2. Definição da URL:

```
url <- "URL do site que será acessado para a raspagem de dados"
```

Aqui, é definida a URL do site que será acessado para a raspagem dos dados. Substitua "URL do site que será acessado para a raspagem de dados" pela URL real.

3. Configuração do servidor RSelenium:

```
rD <- rsDriver()
remDr <- rD$client
```

Essas linhas configuram o servidor RSelenium e criam um cliente RSelenium para interagir com o navegador.

 4. Navegação na página:
``` 
 remDr$navigate(url)
 ```
Essa linha navega até a URL definida anteriormente.

 5. Coleta de dados:
```
elem_tabela <- remDr$findElement(using = 'xpath', value = "//table")
tam <- remDr$findElement(using = 'xpath', value = "//span[@id='lblTotalPages']")$getElementText()
quantidade_paginas <- as.numeric(tam)
todos_dados <- list()
i <- 1
```

Essas linhas localizam o elemento da tabela na página, obtêm o número total de páginas e inicializam as variáveis para armazenar os dados coletados.

 6. Loop de coleta de dados:

```
while (i <= quantidade_paginas) {
  páginaZ_elem <- remDr$findElement(using = 'xpath', value = "//table")
  páginaZ <- read_html(páginaZ_elem$getElementAttribute("outerHTML")[[1]])
  df <- páginaZ %>%
    html_table(fill = TRUE) %>%
    .[[1]]
  todos_dados[[i]] <- df
  Sys.sleep(3)
  btn_proximo <- remDr$findElement(using = 'xpath', value = "//a[@id='lnkNext']")
  if (length(btn_proximo) > 0) {
    btn_proximo$clickElement()
    i <- i + 1
  } else {
    break
  }
}
```
Nesse trecho, um loop é executado para percorrer cada página da tabela. A página atual é convertida em um objeto html, os dados da tabela são extraídos e armazenados em um data frame. Os dados são adicionados à lista  `todos_dados` . Em seguida, há um atraso de 3 segundos para evitar sobrecarga do servidor. Se houver um botão "Próxima página", ele é clicado e o contador  `i`  é incrementado. Caso contrário, o loop é interrompido.

 7. Limpeza dos dados:

```
todos_dados <- rbindlist(todos_dados)
colnames(todos_dados)[3] <- "Agency"
todos_dados$`Annual salary` <- str_remove_all(todos_dados$`Annual salary`, "\\$")
todos_dados$`Annual salary` <- str_replace_all(todos_dados$`Annual salary`, ",", ".")
```

Nessas linhas, os dados coletados são convertidos em um único data frame, o nome da terceira coluna é alterado para "Agency". O símbolo de dólar é removido da coluna "Annual salary" e as vírgulas são substituídas por pontos.

 8. Salvando os dados:

```
write.csv(todos_dados, "nome_do_arquivo.csv", row.names = FALSE)
```

Os dados são salvos em um arquivo CSV com o nome "nome_do_arquivo.csv". Certifique-se de substituir "nome_do_arquivo" pelo nome desejado.

 9. Fechando o cliente e o servidor RSelenium:

```
remDr$close()
rD$server$stop()
```
O cliente RSelenium e o servidor RSelenium são fechados para encerrar a comunicação com o navegador.
 Esses são os principais passos do código, explicados com trechos correspondentes a cada etapa.

Em conclusão, o código fornecido é um exemplo de raspagem de dados em R utilizando o pacote RSelenium. Ele é projetado para extrair informações de salários do Departamento de Segurança Pública do Texas a partir de uma página web específica. 
 Ao longo do código, são utilizadas diversas bibliotecas, como tidyverse, RSelenium, rvest e data.table, para realizar a raspagem, limpeza e manipulação dos dados coletados. 
 O script percorre cada página da tabela de salários, extrai os dados e os armazena em um data frame. Em seguida, realiza a limpeza dos dados, removendo símbolos e formatando as colunas adequadamente. Por fim, os dados são salvos em um arquivo CSV para posterior análise e utilização.
 A utilização do RSelenium permite a interação com o navegador, possibilitando a navegação pelas páginas e extração dos dados desejados. Essa abordagem automatizada é extremamente útil para coletar informações de forma eficiente e precisa.
 Em resumo, o código apresentado é um exemplo prático de como realizar raspagem de dados em R utilizando RSelenium, tornando possível a extração e análise de informações relevantes de uma página web específica.
