library(tidyverse)
library(RSelenium)
library(rvest)
library(data.table)

url <- "https://salaries.texastribune.org/search/?q=%22Department+of+Public+Safety%22"

# Servidor RSelenium
rD <- rsDriver(
  browser = "firefox",
  port = sample(7600)[1],
  verbose = FALSE,
  chromever = NULL
)

remDr <- rD[["client"]]

# Para começar, navegamos para um url
remDr$navigate(url = url)

# Encontrar o elemento "table" da pagina
elem_tabela <- remDr$findElement(using = "id", value = "pagination-table")

tam <- remDr$findElement(using = "xpath",
                         value = "/html/body/main/div[2]/div/div[2]/div[2]/ul/span/li[6]/a")$getElementText()

quantidade_paginas <- as.numeric(tam)
todos_dados <- list()
i <- 1

while (i <= quantidade_paginas) {
  # Extrair dados da Tabela da pagina
  paginaZ_elem <- elem_tabela$getPageSource()
  paginaZ <- read_html(paginaZ_elem %>% unlist())
  df <- html_table(paginaZ) %>% .[[2]]
  todos_dados <- rbindlist(list(todos_dados, df))

  Sys.sleep(0.2)

  if(i != quantidade_paginas){
     btn_proximo <-remDr$findElement(using = 'xpath', value = '//a[@aria-label="Next Page"]')
     btn_proximo$clickElement()
  }

  i <- i + 1
}

colnames(todos_dados)[3] <- "Agency"
todos_dados$`Annual salary` <- str_remove_all(todos_dados$`Annual salary`,"[$]")
todos_dados$`Annual salary` <- str_replace_all(todos_dados$`Annual salary`, ",",".") %>%
  as.numeric()

write.csv(todos_dados,
          file = "D:\\localhost\\Estudos\\Practical Business intelligence\\webScraping\\dados\\dados4.csv",
          row.names = FALSE,
          quote = FALSE
)

# Feche o cliente e o servidor
remDr$close()
rD$server$stop()